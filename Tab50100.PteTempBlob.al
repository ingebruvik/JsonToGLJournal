table 50100 PteTempBlob
{
    Caption = 'PteTempBlob';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Code"; Code[1])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(10; "Blob"; Blob)
        {
            Caption = 'Blob';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
