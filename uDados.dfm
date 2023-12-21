object dmDados: TdmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 416
  Width = 564
  object FDAuxiliar: TFDQuery
    Connection = SqlConexao
    Left = 500
    Top = 85
  end
  object SqlConexao: TFDConnection
    Params.Strings = (
      
        'Database=D:\GIT_PROJETOS\ApiRestDelphi\ApiRestDelphi\BuscaApi\bi' +
        'n\BD.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey')
    LoginPrompt = False
    Left = 500
    Top = 21
  end
  object FDEncomenda: TFDQuery
    Connection = SqlConexao
    SQL.Strings = (
      'Select * from ENCOMENDA')
    Left = 420
    Top = 24
    object FDEncomendaID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      Required = True
    end
    object FDEncomendaCODIGO: TStringField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
    end
    object FDEncomendaNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
    object FDEncomendaCATEGORIA: TStringField
      FieldName = 'CATEGORIA'
      Origin = 'CATEGORIA'
      Size = 30
    end
    object FDEncomendaEMPRESA: TStringField
      FieldName = 'EMPRESA'
      Origin = 'EMPRESA'
      Size = 50
    end
    object FDEncomendaSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      FixedChar = True
      Size = 1
    end
    object FDEncomendaDATA: TDateField
      FieldName = 'DATA'
      Origin = '"DATA"'
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 488
    Top = 149
  end
end
