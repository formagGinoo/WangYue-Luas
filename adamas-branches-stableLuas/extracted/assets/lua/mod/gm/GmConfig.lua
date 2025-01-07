GmConfig = GmConfig or {}

GmConfig.ProtocolExportData = Config.protocolExport --协议导出lua文件
GmConfig.protocolSingleType = {
    int32 = 1,
    uint32 = 2,
    string = 3,
    bool = 4,
    int64 = 5,
    uint64 = 6,
    sint32 = 7,
    sint64 = 8
}