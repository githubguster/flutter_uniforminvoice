#ifndef __NATIVE__ZXINGCPP_H__
#define __NATIVE__ZXINGCPP_H__
#ifdef __cplusplus
extern "C"
{
#endif

    /**
     * @brief barcode format
     */
    enum Format
    {
        None = 0,                   ///< Used as a return value if no valid barcode has been detected
        Aztec = (1 << 0),           ///< Aztec
        Codabar = (1 << 1),         ///< Codabar
        Code39 = (1 << 2),          ///< Code39
        Code93 = (1 << 3),          ///< Code93
        Code128 = (1 << 4),         ///< Code128
        DataBar = (1 << 5),         ///< GS1 DataBar, formerly known as RSS 14
        DataBarExpanded = (1 << 6), ///< GS1 DataBar Expanded, formerly known as RSS EXPANDED
        DataMatrix = (1 << 7),      ///< DataMatrix
        EAN8 = (1 << 8),            ///< EAN-8
        EAN13 = (1 << 9),           ///< EAN-13
        ITF = (1 << 10),            ///< ITF (Interleaved Two of Five)
        MaxiCode = (1 << 11),       ///< MaxiCode
        PDF417 = (1 << 12),         ///< PDF417
        QRCode = (1 << 13),         ///< QR Code
        UPCA = (1 << 14),           ///< UPC-A
        UPCE = (1 << 15),           ///< UPC-E
        MicroQRCode = (1 << 16),    ///< Micro QR Code

        LinearCodes = Codabar | Code39 | Code93 | Code128 | EAN8 | EAN13 | ITF | DataBar | DataBarExpanded | UPCA | UPCE,
        MatrixCodes = Aztec | DataMatrix | MaxiCode | PDF417 | QRCode | MicroQRCode,
        Any = LinearCodes | MatrixCodes,
    };

    /**
     * @brief Position of a barcode in a image
     */
    struct Position
    {
        int imageWidth;   ///< The width of the image
        int imageHeight;  ///< The height of the image
        int topLeftX;     ///< x coordinate of top left corner of barcode
        int topLeftY;     ///< y coordinate of top left corner of barcode
        int topRightX;    ///< x coordinate of top right corner of barcode
        int topRightY;    ///< y coordinate of top right corner of barcode
        int bottomLeftX;  ///< x coordinate of bottom left corner of barcode
        int bottomLeftY;  ///< y coordinate of bottom left corner of barcode
        int bottomRightX; ///< x coordinate of bottom right corner of barcode
        int bottomRightY; ///< y coordinate of bottom right corner of barcode
    };

    /**
     * @brief Encapsulates the result of decoding a barcode within an image.
     */
    struct CodeResult
    {
        int isValid;                ///< Whether the barcode was successfully decoded
        enum Format format;         ///< The format of the barcode
        const char *text;           ///< The decoded text
        const unsigned char *bytes; ///< The bytes is the raw / standard content without any modifications like character set conversions
        int length;                 ///< The length of the bytes
        struct Position *position;  ///< The position of the barcode within the image
        int isInverted;             ///< Whether the barcode was inverted
        int isMirrored;             ///< Whether the barcode was mirrored
        int duration;               ///< The duration of the decoding in milliseconds
        char *error;                ///< The error message
    };

    /**
     * @brief Encapsulates the result of decoding multiple barcodes within an image.
     */
    struct CodeResults
    {
        int count;                  ///< The number of barcodes detected
        struct CodeResult *results; ///< The results of the barcode decoding
    };

    /**
     * @brief Encapsulates the result of encoding a barcode.
     */
    struct EncodeResult
    {
        int isValid;               ///< Whether the barcode was successfully encoded
        enum Format format;        ///< The format of the barcode
        const char *text;          ///< The encoded text
        const unsigned char *data; ///< The encoded data
        int length;                ///< The length of the encoded data
        char *error;               ///< The error message
    };

    /**
     * @brief Enables or disables the logging of the library.
     * @param enabled Whether to enable or disable the logging.
     */
    void setLogEnabled(int enable);

    /**
     * @brief Returns the version of the zxing-cpp library.
     * @return The version of the zxing-cpp library.
     */
    char const *version();

    /**
     * @brief Read barcode from image bytes.
     * @param bytes Image bytes.
     * @param format Specify a set of BarcodeFormats that should be searched for.
     * @param width Image width in pixels.
     * @param height Image height in pixels.
     * @param cropWidth Crop width.
     * @param cropHeight Crop height.
     * @param tryHarder Spend more time to try to find a barcode; optimize for accuracy, not speed.
     * @param tryRotate Also try detecting code in 90, 180 and 270 degree rotated images.
     * @param tryInvert invert images.
     * @return The barcode result.
     */
    struct CodeResult readBarcode(const unsigned char *bytes, enum Format format, int width, int height, int cropWidth, int cropHeight, int tryHarder, int tryRotate, int tryInvert);

    /**
     * @brief Read barcodes from image bytes.
     * @param bytes Image bytes.
     * @param format Specify a set of BarcodeFormats that should be searched for.
     * @param width Image width in pixels.
     * @param height Image height in pixels.
     * @param cropWidth Crop width.
     * @param cropHeight Crop height.
     * @param tryHarder Spend more time to try to find a barcode, optimize for accuracy, not speed.
     * @param tryRotate Also try detecting code in 90, 180 and 270 degree rotated images.
     * @param tryInvert invert images.
     * @return The barcode results.
     */
    struct CodeResults readBarcodes(const unsigned char *bytes, enum Format format, int width, int height, int cropWidth, int cropHeight, int tryHarder, int tryRotate, int tryInvert);

    /**
     * @brief Encode a string into a barcode
     * @param contents The string to encode
     * @param width The width of the barcode in pixels.
     * @param height The height of the barcode in pixels.
     * @param format The format of the barcode
     * @param margin The margin of the barcode
     * @param eccLevel The error correction level of the barcode. Used for Aztec, PDF417, and QRCode only, [0-8].
     * @return The barcode .
     */
    struct EncodeResult encodeBarcode(const char *contents, int width, int height, enum Format format, int margin, int eccLevel);

    /**
     * @brief free menory
     * @param result The barcode result.
     */
    void freeCodeResult(struct CodeResult result);

    /**
     * @brief free menory
     * @param result The barcode results.
     */
    void freeCodeResults(struct CodeResults results);

    /**
     * @brief free menory
     * @param result The barcode data.
     */
    void freeEncodeResult(struct EncodeResult result);
#ifdef __cplusplus
}
#endif
#endif