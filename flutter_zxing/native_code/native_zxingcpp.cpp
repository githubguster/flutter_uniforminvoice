#include <stdarg.h>
#include <locale>
#include <codecvt>
#include <ReadBarcode.h>
#include <MultiFormatWriter.h>
#include <TextUtfEncoding.h>
#include <BitMatrix.h>
#include "common.h"
#include "native_zxingcpp.h"

#ifdef __cplusplus
extern "C"
{
#endif

#define ZXING_VERSION "2.2.1"

    FUNCTION_ATTRIBUTE
    void setLogEnabled(int enable)
    {
        setLoggingEnabled(enable);
    }

    FUNCTION_ATTRIBUTE
    char const *version()
    {
        return ZXING_VERSION;
    }

    static void resultToCodeResult(struct CodeResult *code, int width, int height, ZXing::Result result)
    {
        code->isValid = result.isValid();
        code->format = static_cast<enum Format>(result.format());
        code->bytes = result.bytes().data();
        code->length = result.bytes().size();

        std::string resultText = result.text();
        char *text = new char[resultText.length() + 1];
        strcpy(text, resultText.c_str());
        code->text = text;

        std::string errorText = result.error().msg();
        if (!errorText.empty())
        {
            code->error = new char[errorText.length() + 1];
            strcpy(code->error, errorText.c_str());
        }

        auto p = result.position();
        auto tl = p.topLeft();
        auto tr = p.topRight();
        auto bl = p.bottomLeft();
        auto br = p.bottomRight();
        code->position = new Position{width, height, tl.x, tl.y, tr.x, tr.y, bl.x, bl.y, br.x, br.y};
        platform_log("Result: %s\n", code->text);
    }

    FUNCTION_ATTRIBUTE
    struct CodeResult readBarcode(const unsigned char *bytes, enum Format format, int width, int height, int cropWidth, int cropHeight, int tryHarder, int tryRotate, int tryInvert)
    {
        long long start = get_now();
        long length = static_cast<long>(width * height);
        uint8_t *data = new uint8_t[length];
        memcpy(data, bytes, length);

        ZXing::ImageView image{data, width, height, ZXing::ImageFormat::Lum};
        if (cropWidth > 0 && cropHeight > 0 && cropWidth < width && cropHeight < height)
        {
            image = image.cropped(width / 2 - cropWidth / 2, height / 2 - cropHeight / 2, cropWidth, cropHeight);
        }
        ZXing::ReaderOptions hints = ZXing::ReaderOptions()
                                       .setTryHarder(static_cast<bool>(tryHarder))
                                       .setTryRotate(static_cast<bool>(tryRotate))
                                       .setTryInvert(static_cast<bool>(tryInvert))
                                       .setIsPure(false)
                                       .setReturnErrors(true)
                                       .setFormats(ZXing::BarcodeFormat(static_cast<int>(format)));
        ZXing::Result result = ReadBarcode(image, hints);

        struct CodeResult code = {false, format, nullptr, nullptr, 0, nullptr, 0, 0, 0, nullptr};
        if (result.isValid())
        {
            resultToCodeResult(&code, width, height, result);
        }

        delete[] data;
        delete[] bytes;

        int evalInMillis = static_cast<int>(get_now() - start);
        code.duration = evalInMillis;
        platform_log("Read Barcode in: %d ms\n", evalInMillis);
        return code;
    }

    FUNCTION_ATTRIBUTE
    struct CodeResults readBarcodes(const unsigned char *bytes, enum Format format, int width, int height, int cropWidth, int cropHeight, int tryHarder, int tryRotate, int tryInvert)
    {
        long long start = get_now();

        long length = width * height;
        auto *data = new uint8_t[length];
        memcpy(data, bytes, length);

        ZXing::ImageView image{data, width, height, ZXing::ImageFormat::Lum};
        if (cropWidth > 0 && cropHeight > 0 && cropWidth < width && cropHeight < height)
        {
            image = image.cropped(width / 2 - cropWidth / 2, height / 2 - cropHeight / 2, cropWidth, cropHeight);
        }
        ZXing::ReaderOptions hints = ZXing::ReaderOptions()
                                       .setTryHarder(static_cast<bool>(tryHarder))
                                       .setTryRotate(static_cast<bool>(tryRotate))
                                       .setTryInvert(static_cast<bool>(tryInvert))
                                       .setIsPure(false)
                                       .setReturnErrors(true)
                                       .setFormats(ZXing::BarcodeFormat(static_cast<int>(format)));
        ZXing::Results results = ReadBarcodes(image, hints);

        int evalInMillis = static_cast<int>(get_now() - start);
        struct CodeResult *codes = new struct CodeResult[results.size()];
        int i = 0;
        for (auto &result : results)
        {
            struct CodeResult code = {false, format, nullptr, nullptr, 0, nullptr, 0, 0, 0, nullptr};
            if (result.isValid())
            {
                resultToCodeResult(&code, width, height, result);
                code.duration = evalInMillis;
                codes[i] = code;
                i++;
            }
        }

        delete[] data;
        delete[] bytes;

        platform_log("Read Barcode in: %d ms\n", evalInMillis);
        return {i, codes};
    }

    FUNCTION_ATTRIBUTE
    struct EncodeResult encodeBarcode(const char *contents, int width, int height, enum Format format, int margin, int eccLevel)
    {
        long long start = get_now();

        struct EncodeResult result = {false, format, contents, nullptr, 0, nullptr};
        try
        {
            auto writer = ZXing::MultiFormatWriter(ZXing::BarcodeFormat(format))
                              .setMargin(margin)
                              .setEccLevel(eccLevel)
                              .setEncoding(ZXing::CharacterSet::UTF8);
            auto bitMatrix = writer.encode(ZXing::TextUtfEncoding::FromUtf8(std::string(contents)), width, height);
            result.data = ZXing::ToMatrix<uint8_t>(bitMatrix).data();
            result.length = bitMatrix.width() * bitMatrix.height();
            result.isValid = true;
        }
        catch (const std::exception &e)
        {
            platform_log("Can't encode text: %s\nError: %s\n", contents, e.what());
            result.error = new char[strlen(e.what()) + 1];
            strcpy(result.error, e.what());
        }

        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Encode Barcode in: %d ms\n", evalInMillis);
        return result;
    }

    FUNCTION_ATTRIBUTE
    void freeCodeResult(struct CodeResult result)
    {
        if (result.text != nullptr)
        {
            delete result.text;
            result.text = nullptr;
        }

        if (result.error != nullptr)
        {
            delete result.error;
            result.error = nullptr;
        }

        memset(&result, 0, sizeof(struct CodeResult));
    }

    FUNCTION_ATTRIBUTE
    void freeCodeResults(struct CodeResults results)
    {
        if (results.results != nullptr)
        {
            for (int i = 0; i < results.count; i++)
            {
                freeCodeResult(results.results[i]);
            }
            delete results.results;
            results.results = nullptr;
        }

        memset(&results, 0, sizeof(struct CodeResults));
    }

    FUNCTION_ATTRIBUTE
    void freeEncodeResult(struct EncodeResult result)
    {
        if (result.error != nullptr)
        {
            delete result.error;
            result.error = nullptr;
        }

        memset(&result, 0, sizeof(struct EncodeResult));
    }

#ifdef __cplusplus
}
#endif