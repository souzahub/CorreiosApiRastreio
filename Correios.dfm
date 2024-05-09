object formCorreios: TformCorreios
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Rastreio Encomendas'
  ClientHeight = 435
  ClientWidth = 897
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 897
    Height = 435
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 1079
    ExplicitHeight = 433
    object btBuscar: TStyledButton
      Left = 200
      Top = 24
      Width = 105
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      OnClick = btBuscarClick
      ParentFont = False
      Caption = 'Rastrear manual'
      StyleDrawType = btRounded
      StyleFamily = 'Bootstrap'
      TabOrder = 1
    end
    object lbTotal: TLabel
      Left = 16
      Top = 9
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Label1: TLabel
      Left = 16
      Top = 53
      Width = 127
      Height = 13
      Cursor = crHandPoint
      Caption = 'BY : https://linketrack.com'
    end
    object btCorreio: TStyledButton
      Left = 763
      Top = 9
      Width = 130
      Height = 54
      DragCursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      OnClick = btCorreioClick
      ParentFont = False
      Caption = 'BUSCA C'#211'DIGO'
      StyleDrawType = btRounded
      StyleFamily = 'Bootstrap'
      StyleClass = 'Success'
      TabOrder = 3
    end
    object label001: TLabel
      Left = 376
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Label2'
      Visible = False
    end
    object edCodRestreio: TEdit
      Left = 16
      Top = 28
      Width = 169
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      TextHint = 'RASTREIO'
    end
    object pnGrid: TPanel
      Left = 0
      Top = 71
      Width = 897
      Height = 364
      Align = alBottom
      TabOrder = 2
      ExplicitTop = 69
      ExplicitWidth = 1079
      object DBGrid1: TDBGrid
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 889
        Height = 356
        Align = alClient
        DataSource = dsBusca
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [dgTitles, dgRowLines, dgTabs, dgRowSelect, dgTitleHotTrack]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'data'
            Title.Caption = 'Data'
            Width = 104
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'hora'
            Title.Caption = 'Hora'
            Width = 71
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'local'
            Title.Caption = 'Local'
            Width = 191
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'status'
            Title.Caption = 'Status'
            Width = 500
            Visible = True
          end>
      end
    end
    object Button1: TButton
      Left = 376
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Task'
      TabOrder = 4
      Visible = False
      OnClick = Button1Click
    end
  end
  object dsBusca: TDataSource
    DataSet = FDMemTable1
    Left = 264
    Top = 248
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 48
    Top = 240
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 160
    Top = 248
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'eventos'
    Left = 48
    Top = 344
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponse1
    Left = 176
    Top = 344
  end
  object FDMemTable1: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 40
    Top = 152
    object FDMemTable1data: TWideStringField
      FieldName = 'data'
      Size = 255
    end
    object FDMemTable1hora: TWideStringField
      FieldName = 'hora'
      Size = 255
    end
    object FDMemTable1local: TWideStringField
      FieldName = 'local'
      Size = 255
    end
    object FDMemTable1status: TWideStringField
      FieldName = 'status'
      Size = 255
    end
    object FDMemTable1subStatus: TWideStringField
      FieldName = 'subStatus'
      Size = 255
    end
  end
end
