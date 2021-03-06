module Page.UserSettings.View2 exposing (viewContent, viewSidebar)

import Comp.ChangePasswordForm
import Comp.EmailSettingsManage
import Comp.ImapSettingsManage
import Comp.NotificationManage
import Comp.ScanMailboxManage
import Comp.UiSettingsManage
import Data.Flags exposing (Flags)
import Data.UiSettings exposing (UiSettings)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Page.UserSettings.Data exposing (..)
import Styles as S


viewSidebar : Bool -> Flags -> UiSettings -> Model -> Html Msg
viewSidebar visible _ _ model =
    div
        [ id "sidebar"
        , class S.sidebar
        , class S.sidebarBg
        , classList [ ( "hidden", not visible ) ]
        ]
        [ div [ class "" ]
            [ h1 [ class S.header1 ]
                [ text "User Settings"
                ]
            ]
        , div [ class "flex flex-col my-2" ]
            [ a
                [ href "#"
                , onClick (SetTab UiSettingsTab)
                , menuEntryActive model UiSettingsTab
                , class S.sidebarLink
                ]
                [ i [ class "fa fa-cog" ] []
                , span
                    [ class "ml-3" ]
                    [ text "UI Settings" ]
                ]
            , a
                [ href "#"
                , onClick (SetTab NotificationTab)
                , menuEntryActive model NotificationTab
                , class S.sidebarLink
                ]
                [ i [ class "fa fa-bullhorn" ] []
                , span
                    [ class "ml-3" ]
                    [ text "Notifications" ]
                ]
            , a
                [ href "#"
                , onClick (SetTab ScanMailboxTab)
                , menuEntryActive model ScanMailboxTab
                , class S.sidebarLink
                ]
                [ i [ class "fa fa-envelope-open font-thin" ] []
                , span
                    [ class "ml-3" ]
                    [ text "Scan Mailbox" ]
                ]
            , a
                [ href "#"
                , onClick (SetTab EmailSettingsTab)
                , class S.sidebarLink
                , menuEntryActive model EmailSettingsTab
                ]
                [ i [ class "fa fa-envelope" ] []
                , span
                    [ class "ml-3" ]
                    [ text "E-Mail Settings (SMTP)" ]
                ]
            , a
                [ href "#"
                , onClick (SetTab ImapSettingsTab)
                , menuEntryActive model ImapSettingsTab
                , class S.sidebarLink
                ]
                [ i [ class "fa fa-envelope" ] []
                , span
                    [ class "ml-3" ]
                    [ text "E-Mail Settings (IMAP)" ]
                ]
            , a
                [ href "#"
                , onClick (SetTab ChangePassTab)
                , menuEntryActive model ChangePassTab
                , class S.sidebarLink
                ]
                [ i [ class "fa fa-user-secret" ] []
                , span
                    [ class "ml-3" ]
                    [ text "Change Password" ]
                ]
            ]
        ]


viewContent : Flags -> UiSettings -> Model -> Html Msg
viewContent flags settings model =
    div
        [ id "content"
        , class S.content
        ]
        (case model.currentTab of
            Just ChangePassTab ->
                viewChangePassword model

            Just EmailSettingsTab ->
                viewEmailSettings settings model

            Just NotificationTab ->
                viewNotificationManage settings model

            Just ImapSettingsTab ->
                viewImapSettings settings model

            Just ScanMailboxTab ->
                viewScanMailboxManage settings model

            Just UiSettingsTab ->
                viewUiSettings flags settings model

            Nothing ->
                []
        )



--- Helper


menuEntryActive : Model -> Tab -> Attribute msg
menuEntryActive model tab =
    if model.currentTab == Just tab then
        class S.sidebarMenuItemActive

    else
        class ""


viewChangePassword : Model -> List (Html Msg)
viewChangePassword model =
    [ h2
        [ class S.header1
        , class "inline-flex items-center"
        ]
        [ i [ class "fa fa-user-secret" ] []
        , div [ class "ml-3" ]
            [ text "Change Password"
            ]
        ]
    , Html.map ChangePassMsg (Comp.ChangePasswordForm.view2 model.changePassModel)
    ]


viewUiSettings : Flags -> UiSettings -> Model -> List (Html Msg)
viewUiSettings flags settings model =
    [ h2
        [ class S.header1
        , class "inline-flex items-center"
        ]
        [ i [ class "fa fa-cog" ] []
        , span [ class "ml-3" ]
            [ text "UI Settings"
            ]
        ]
    , p [ class "opacity-75 text-lg mb-4" ]
        [ text "These settings only affect the web ui. They are stored in the browser, "
        , text "so they are separated between browsers and devices."
        ]
    , Html.map UiSettingsMsg
        (Comp.UiSettingsManage.view2
            flags
            settings
            ""
            model.uiSettingsModel
        )
    ]


viewEmailSettings : UiSettings -> Model -> List (Html Msg)
viewEmailSettings settings model =
    [ h2
        [ class S.header1
        , class "inline-flex items-center"
        ]
        [ i [ class "fa fa-envelope" ] []
        , div [ class "ml-3" ]
            [ text "E-Mail Settings (Smtp)"
            ]
        ]
    , Html.map EmailSettingsMsg
        (Comp.EmailSettingsManage.view2
            settings
            model.emailSettingsModel
        )
    ]


viewImapSettings : UiSettings -> Model -> List (Html Msg)
viewImapSettings settings model =
    [ h2
        [ class S.header1
        , class "inline-flex items-center"
        ]
        [ i [ class "fa fa-envelope" ] []
        , div [ class "ml-3" ]
            [ text "E-Mail Settings (Imap)"
            ]
        ]
    , Html.map ImapSettingsMsg
        (Comp.ImapSettingsManage.view2
            settings
            model.imapSettingsModel
        )
    ]


viewNotificationManage : UiSettings -> Model -> List (Html Msg)
viewNotificationManage settings model =
    [ h2
        [ class S.header1
        , class "inline-flex items-center"
        ]
        [ i [ class "fa fa-bullhorn" ] []
        , div [ class "ml-3" ]
            [ text "Notification"
            ]
        ]
    , p [ class "opacity-80 text-lg mb-3" ]
        [ text """
            Docspell can notify you once the due dates of your items
            come closer. Notification is done via e-mail. You need to
            provide a connection in your e-mail settings."""
        ]
    , p [ class "opacity-80 text-lg mb-3" ]
        [ text "Docspell finds all items that are due in "
        , em [ class "font-italic" ] [ text "Remind Days" ]
        , text " days and sends this list via e-mail."
        ]
    , Html.map NotificationMsg
        (Comp.NotificationManage.view2 settings model.notificationModel)
    ]


viewScanMailboxManage : UiSettings -> Model -> List (Html Msg)
viewScanMailboxManage settings model =
    [ h2
        [ class S.header1
        , class "inline-flex items-center"
        ]
        [ i [ class "fa fa-envelope-open font-thin" ] []
        , div [ class "ml-3" ]
            [ text "Scan Mailbox"
            ]
        ]
    , p [ class "opacity-80 text-lg mb-3" ]
        [ text "Docspell can scan folders of your mailbox to import your mails. "
        , text "You need to provide a connection in "
        , text "your e-mail (imap) settings."
        ]
    , p [ class "opacity-80 text-lg mb-3 hidden" ]
        [ text """
            Docspell goes through all configured folders and imports
            mails matching the search criteria. Mails are skipped if
            they were imported in a previous run and the corresponding
            items still exist. After submitting a mail into docspell,
            you can choose to move it to another folder, to delete it
            or to just leave it there. In the latter case you should
            adjust the schedule to avoid reading over the same mails
            again."""
        ]
    , Html.map ScanMailboxMsg
        (Comp.ScanMailboxManage.view2
            settings
            model.scanMailboxModel
        )
    ]
