from PyQt5.QtWidgets import *
from PyQt5 import uic
from pyswip import Prolog
import string
prolog = Prolog()
prolog.consult("data/knowledge_base.pl")
class MyGUI(QMainWindow):

    def __init__(self):
        super(MyGUI,self).__init__()
        
        uic.loadUi("xml/mainui.ui",self)
        self.textBrowser.append("<span>Chat Bot Started &#128513;  <p>Bot: Hello, can i help you?  type help to get options.</p> </span>")
        # self.textBrowser.append("<span>goodbye</span><br>")
        self.pushButton.clicked.connect(self.getMessage)

        self.show()

    def getMessage(self):
        print(self.lineEdit.text())
        text = self.lineEdit.text()
        punctuations = string.punctuation
        no_punct_table = str.maketrans('', '', punctuations)
        text = text.translate(no_punct_table)
        self.lineEdit.setText("")
        if text.strip():
            if 'help' in text:
                self.textBrowser.append("<span> User: "+text+"</span>")
                self.lineEdit.setText("")
                self.textBrowser.append("<span> Bot: The available  topics &#128513;:</span>")
                self.textBrowser.append("<span> * sustainable.</span>")
                self.textBrowser.append("<span> * energy_saving.</span>")
                self.textBrowser.append("<span> * environmentally.</span>")
                self.textBrowser.append("<span>You can have a dialogue about these topics.</span>")
                
            else:
                self.textBrowser.append("<span> User: "+text+"</span>")
                flag = False
                resp = prolog.query("question_answer('"+text.lower()+"',X)")
                for r in resp:
                    flag=True
                    self.textBrowser.append("<span> Bot: "+r['X']+".</span>")
                    print(r['X'])
               
                resp = prolog.query("get_List('"+text.lower()+"',R)")
                for r in resp:
                    self.textBrowser.append("<span> Bot: you should do:</span>")
                    conter = 0
                    for i in r['R']:
                        flag=True
                        conter =conter+1
                        self.textBrowser.append("<span>"+str(conter)+"-"+str(i)+" .</span>")
                if flag == False:
                    self.textBrowser.append("<span> Bot: Sorry, can not Answer you.</span>")
                    self.lineEdit.setText("")

    
def main():
    app = QApplication([])
    window = MyGUI()
    app.exec_()
if __name__ == '__main__':
    main()