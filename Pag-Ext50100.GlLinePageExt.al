/// <summary>
/// PageExtension GlLinePageExt (ID 50100) extends Record General Journal.
/// </summary>
pageextension 50100 GlLinePageExt extends "General Journal"
{
    actions
    {
        addfirst(processing)
        {
            action(ReadLinesJson)
            {
                Caption = 'Read lines from Json file';
                ApplicationArea = all;
                trigger OnAction()

                var
                    JsonBuffer: Record "JSON Buffer" temporary;
                    PteTempBlob: Record PteTempBlob;
                    JournalLine: Record "Gen. Journal Line";
                    filename: text;
                    Ins: InStream;
                    OutS: OutStream;
                    Json: JsonObject;
                    PteBlobRecordRef: RecordRef;
                    BlobFieldRef: FieldRef;
                    JsonText: Text;
                    TempBlob: Codeunit "Temp Blob";
                    LineNo: Integer;

                begin
                    PteTempBlob.DeleteAll();
                    PteBlobRecordRef.Open(database::PteTempBlob);
                    BlobFieldRef := PteBlobRecordRef.Field(10);
                    // BlobFieldRef.CreateOutStream(OutS);
                    if UploadIntoStream('Give me the Json', '', '', filename, Ins) then begin
                        PteTempBlob.Init();
                        PteTempBlob.Code := '1';
                        PteTempBlob.Blob.CreateOutStream(OutS);
                        CopyStream(OutS, Ins);
                        PteTempBlob.Insert(true);
                        PteBlobRecordRef.get(PteTempBlob.RecordId);
                        BlobFieldRef := PteBlobRecordRef.Field(10);
                        BlobFieldRef.CalcField();
                        JsonBuffer.ReadFromBlob(BlobFieldRef);
                        LineNo := 10000;
                        if JsonBuffer.FindSet() then
                            repeat
                                if JsonBuffer.Path.Contains('DIARIO_ORIGEN')
                                then begin
                                    JournalLine.Init();
                                    JournalLine."Line No." := LineNo;
                                    LineNo += 10000;
                                    JournalLine.Validate("Journal Template Name", JsonBuffer.Value);
                                end;
                                if JsonBuffer.Path.Contains('DIARIO_LOTE') then begin
                                    JournalLine.Validate("Journal Batch Name", JsonBuffer.Value);
                                    JournalLine.Insert(true);
                                end;

                            //parse the rest of your json here

                            until JsonBuffer.Next() = 0;


                    end;
                end;

            }
        }
    }

}
