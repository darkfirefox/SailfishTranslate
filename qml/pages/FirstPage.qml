import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

Page {
    id: page
    allowedOrientations: Orientation.All


    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Show history")
                onClicked: pageStack.push(Qt.resolvedUrl("HistoryPage.qml"))
            }
        }

        contentHeight: column.height
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Transalator")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("from:")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            ComboBox{
                id: langFrom
                menu:ContextMenu{
                    MenuItem{text:"English"}
                    MenuItem{text:"Russian"}
                    MenuItem{text:"France"}
                    MenuItem{text:"German"}
                    MenuItem{text:"Italian"}
                }
            }

            Button{
                text: qsTr("<==>")
                onClicked: function(){
                    var temp=langTo.currentIndex
                    langTo.currentIndex=langFrom.currentIndex
                    langFrom.currentIndex=temp
                }
            }
            Label{
                x: Theme.horizontalPageMargin
                text: qsTr("to:")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }


            ComboBox{
                id: langTo
                menu:ContextMenu{
                    MenuItem{text:"English"}
                    MenuItem{text:"Russian"}
                    MenuItem{text:"France"}
                    MenuItem{text:"German"}
                    MenuItem{text:"Italian"}
                }
            }
            TextField{
                id: sourceText
                placeholderText: "Enter text from translate"
                placeholderColor: "white"
                color: "white"
            }
            Text{
                id: translText
                color: "red"
                text: qsTr("")
            }

            Button{
                text: qsTr("Translate")
                onClicked: {
                    var request  = new XMLHttpRequest();
                    request.open('GET','https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20180820T201359Z.206166e00728c4ef.a8714d01ec570dd4d870cd24910324416cd70eaa&text='+sourceText.text+'
&lang='+getLang(langFrom)+'-'+getLang(langTo))
                    request.onreadystatechange = function() {
                        if (request.readyState === XMLHttpRequest.DONE) {
                            if (request.status && request.status === 200) {
                                var result = JSON.parse(request.responseText)
                                translText.text = result.text[0]
                                JS.dbInsertRow("en", sourceText.text, "to",result.text[0])
                            } else {
                                console.log("HTTP:", request.status, request.statusText)
                            }
                        }
                    }
                    request.send();
                }
            }

        }
        Component.onCompleted: {
                JS.dbInit()
                langTo.currentIndex=1
            }
    }
    function getLang(cB){
        switch(cB.currentIndex){
        case 0: return "en"
        case 1: return "ru"
        case 2: return "fr"
        case 3: return "de"
        case 4: return "it"
        }
        return ""
    }
}
