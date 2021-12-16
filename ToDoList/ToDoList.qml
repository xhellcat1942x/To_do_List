import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.0
import QtQuick.Timeline 1.0




Window {
    id: window
    width: 800
    height: 480
    visible: true

    //Properties:
    //Popup Properties:
    property bool popupClickOffVis: false
    property bool popupVis: false
    property bool popupAddTaskVis: false
    property bool popupEditTaskVis: false
    property string taskClicked
    property string globTaskName: ''
    property int globButId: 0
    property int globNum: 0

    //Function properties:
    property int i: 1
    property var button: button

    //Functions:
    //Add task functions:
    function editExistingTask()
    {
        //ADD FUNCTIONALITY TO DELETE OLD TASK AND ADD NEW TASK
        testModel.debug(globButId, globTaskName)
    }

    function deleteTask()
    {
        //ADD CALL TO BACKEND TO DELETE TASK FROM DF
        for (var x = 0; x < taskColumn.children.length; ++x){
            if (taskColumn.children[x].buttonId === taskClicked){
                taskColumn.children[x].destroy()
                popupClickOffVis = false
                popupVis = false
                popupEditTaskVis = false
            }
        }
    }

    function taskBoxReAn()
    {
        timelineAnimationTB.start()
    }

    function destroyButtons()
    {
//        for (var i = 0; i < taskColumn.children.length; ++i){
//            testModel.debug("debug", taskColumn.children[i].buttonId)
//        }

        for (var x = taskColumn.children.length ; x > 1 ; x--){
            taskColumn.children[x-1].destroy()
        }

    }

    function getDate(day, update)
    {
        testModel.getDatePy(day, update, buttonGoToToday.text)
    }

    function addTaskX(task, date)
    {
        console.log(date)
        testModel.addTaskPy(task, date, date)
        popupClickOffVis = false
        popupVis = false
        popupAddTaskVis = false
    }

    function buttonClicked(buttonId, taskName)
    {
        testModel.debug(buttonId, taskName)
        globButId = buttonId
        globTaskName = taskName
//        testModel.debug(globButId, globTaskName)





        textEdit1.text = taskName
        taskClicked = buttonId
//        testModel.debug(taskClicked, "")
        popupClickOffVis = true
        popupVis = true
        popupEditTaskVis = true

    }
    function createButton(task, testNum)
    {
        var component = Qt.createComponent("Button.qml");
        var assignMargin
        var id = `button${i}`
        if (i == 1){
            assignMargin = 20
        } else{
            assignMargin = i * 90
        }


        var button = component.createObject(taskColumn,{
                                                "x":0,
                                                "id": id,
//                                                "num": testNum,
                                                "buttonId": testNum,
                                                "taskName": task, //Text displayed
                                                "anchors.left": taskColumn.left,
                                                "anchors.right": taskColumn.right,
                                                "anchors.rightMargin": 20,
                                                "anchors.leftMargin": 20
                                            });

        //Connect the clicked signal of the newly created button
        //to the event handler buttonClicked.
        button.clicked.connect(buttonClicked)
        i += 1
        testModel.debug('', '', testNum)


    }
    Connections {
        target: buttonEditOk
        onClicked: {
            editExistingTask()
        }
    }

    Connections {
        target: buttonDeleteTask
        onClicked: {
            deleteTask()
        }
    }

    Connections {
        target: buttonDisplay
        onClicked:{
            taskBoxReAn()
        }
    }

    Connections {
        target: buttonPopupAddTask
        onClicked: {
            addTaskX(textEdit.text, date)
        }
    }
    Connections {
        target: buttonGoToToday
        onClicked: {
            getDate(0, true)
        }
    }
    Rectangle {
        id: rectangleTopMenu
        x: 300
        height: 66
        color: "#ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        z: 1
        clip: false
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Button {
            id: buttonLeftMenu
            text: qsTr("Menu")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Image {
            id: imageLogo
            x: 135
            width: 135
            height: 92
            anchors.verticalCenter: parent.verticalCenter
            source: "images/VooDoo.png"
            mipmap: true
            sourceSize.height: 200
            sourceSize.width: 400
            autoTransform: false
            smooth: true
            anchors.verticalCenterOffset: 1
            fillMode: Image.PreserveAspectFit
        }

        Button {
            id: buttonGoToToday
            x: 271
            text: qsTr(date)
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
        }

        Button {
            id: buttonPrev
            x: 421
            width: 20
            height: 20
            text: qsTr("<")
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            id: buttonNext
            x: 459
            width: 20
            height: 20
            text: qsTr(">")
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
        }

        Button {
            id: buttonDate
            x: 517
            text: qsTr("Button")
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            id: buttonDisplay
            x: 639
            text: qsTr("Day")
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            id: buttonSettings
            x: 760
            width: 25
            height: 19
            text: qsTr("Settings")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
        }

    }

    Connections {
        target: buttonPrev
        onClicked: {
            getDate(-1, true)
        }
    }
    Rectangle {
        id: taskBox
        color: "#ffffff"
        anchors.left: rectangleLeftMenu.right
        anchors.right: parent.right
        anchors.top: rectangleTopMenu.bottom
        anchors.bottom: parent.bottom
        z: 0
        clip: true
        anchors.leftMargin: 0
        anchors.topMargin: -66
        anchors.bottomMargin: 414
        anchors.rightMargin: 0



        Flickable {
            id: flickable
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            contentHeight: taskColumn.height
            clip: true


            Column {
                id: taskColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                bottomPadding: 20
                topPadding: 20
                spacing: 5

                RoundButton {
                    id: buttonAddTask
                    width: 100
                    height: 40
                    visible: true
                    text: qsTr("Add New Task")
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    antialiasing: false
                    font.strikeout: false
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    highlighted: false
                    flat: false
                    font.bold: true
                    font.pointSize: 10

                    background: Rectangle {
                        radius: buttonAddTask.radius
                        color: buttonAddTask.pressed ? "blue" : "#3664d4"
                    }

                    contentItem: Text{
                        text: buttonAddTask.text
                        font: buttonAddTask.font
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                    }


                    Connections {
                        target: buttonAddTask
                        onClicked: {
                            popupClickOffVis = true
                            popupVis = true
                            popupAddTaskVis = true
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: buttonNext
        onClicked: {
            getDate(1, true)
        }
    }









    Rectangle {
        id: rectangleLeftMenu
        width: 0
        color: "#ffffff"
        anchors.left: parent.left
        anchors.top: rectangleTopMenu.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Rectangle {
            id: rectangle3
            x: 40
            height: 84
            color: "#2e2a4b"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 51
            anchors.leftMargin: 51
        }
    }


    Rectangle {
        id: popupClickOff
        opacity: 0.5
        visible: popupClickOffVis
        color: "#5f5e5e"
        anchors.fill: parent
        layer.enabled: false
        clip: false

        Button {
            id: buttonClickOff
            opacity: 0
            text: qsTr("")
            anchors.fill: parent
            visible: popupClickOffVis

            Connections {
                target: buttonClickOff
                onClicked: {
                    popupClickOffVis = false
                    popupVis = false
                    popupAddTaskVis = false
                }
            }
        }
    }

    Rectangle {
        id: popup
        width: 400
        height: 200
        visible: popupVis
        color: "#fefefe"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: popupAddTask
            visible: popupAddTaskVis
            color: "#ffffff"
            anchors.fill: parent

            TextEdit {
                id: textEdit
                x: 160
                text: qsTr("Enter your task here!")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                font.pixelSize: 16
                z: 0
                clip: false
                anchors.bottomMargin: 80
                anchors.rightMargin: 20
                anchors.leftMargin: 20
                anchors.topMargin: 20
            }

            Button {
                id: buttonPopupAddTask
                x: 138
                text: qsTr("Add Task")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: textEdit.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 20
                anchors.rightMargin: 150
                anchors.leftMargin: 150
                anchors.bottomMargin: 20




            }
        }

        Rectangle {
            id: editTask
            visible: popupEditTaskVis
            color: "#ffffff"
            anchors.fill: parent

            TextEdit {
                id: textEdit1
                text: textTask
                anchors.fill: parent
                font.pixelSize: 12
                anchors.rightMargin: 20
                anchors.leftMargin: 20
                anchors.bottomMargin: 80
                anchors.topMargin: 20
            }

            Button {
                id: buttonEditOk
                x: 46
                text: qsTr("OK")
                anchors.right: textEdit1.horizontalCenter
                anchors.top: textEdit1.bottom
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.bottomMargin: 20
                anchors.topMargin: 20
            }

            Button {
                id: buttonDeleteTask
                text: qsTr("Delete")
                anchors.left: textEdit1.horizontalCenter
                anchors.top: textEdit1.bottom
                anchors.bottom: parent.bottom
                anchors.leftMargin: 20
                anchors.bottomMargin: 20
                anchors.topMargin: 20
            }
        }
    }

    Timeline {
        id: timelineTaskBox
        animations: [
            TimelineAnimation {
                id: timelineAnimationTB
                running: true
                duration: 250
                loops: 1
                to: 250
                from: 0
            }
        ]
        startFrame: 0
        endFrame: 250
        enabled: true

        KeyframeGroup {
            target: taskBox
            property: "anchors.topMargin"

            Keyframe {
                value: 0
                frame: 250
            }

            Keyframe {
                value: -66
                frame: 0
            }
        }

        KeyframeGroup {
            target: taskBox
            property: "anchors.bottomMargin"

            Keyframe {
                easing.bezierCurve: [0.446,0.00556,0.998,-0.0107,1,1]
                value: 0
                frame: 250
            }

            Keyframe {
                value: 414
                frame: 0
            }
        }
    }

}

