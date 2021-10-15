import sys
import pandas as pd  
import numpy as np  
import matplotlib.pyplot as plt  
from sklearn.model_selection import train_test_split  
from sklearn.svm import SVC  
from sklearn.metrics import classification_report, confusion_matrix  
np.set_printoptions(threshold=sys.maxsize)


bankdata = pd.read_csv("../../data/data.csv")  
bankdata.shape  
bankdata.head()

classData=bankdata['class'].unique();
mapingClass={}
count=0;
for key in classData:
    mapingClass[key]=count
    count+=1;

#print (classData[0])
#bankdata.plot()i
#plt.show()
fr=0;
to=classData.size;
dataZ={};
for i in range(fr,to):
    tmp=i
    for j in range(to-(i+1),to):
        if(j==i-tmp):
            continue
        print (str(i-tmp)+"-"+str(j))
        dataZ[str(i-tmp)+"-"+str(j)]=bankdata.loc[(bankdata['class']==classData[(i-tmp)]) | (bankdata['class']==classData[j])]
        tmp-=1



#X = bankdata.loc[(bankdata['class'] == "one") | (bankdata['class'] == "two")].drop('class', axis=1)  
#y = (bankdata.loc[(bankdata['class'] == "one") | (bankdata['class'] == "two")])['class']  
#print (bankdata['class'].unique())

data_test=pd.read_csv("../../data/data-tmp.csv")
x_tests=data_test.drop('class', axis=1)  
y_tests = data_test['class']  
# TODO LOOP x test line by line for each for(dibawah)
#print (len(x_tests.values.tolist()))
#print(x_tests[0][1])
y_pr=[]
st=0;
fn=len(x_tests.values.tolist())
for x_test in x_tests.values.tolist():
    print (str(st)+" - "+str(fn))
    st+=1;
    count=0;
    for i in range(fr,to):

        if(count==0):
            a=i
            b=to-1
        if(a==b):
            print("cacth")
            continue;
        #X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.20)  
        #X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, stratify=y, random_state=1)
        #print(str(a)+" - "+str(b))
        svclassifier = SVC(kernel='linear')  

        svclassifier.fit(dataZ[str(a)+"-"+str(b)].drop('class',axis=1), dataZ[str(a)+"-"+str(b)]['class'])  
        #print(X_test)
        #y_pred = svclassifier.predict([[0,0,0,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0]])  
        y_pred = svclassifier.predict([x_test])
        print(y_pred)
        y_pr.append(y_pred[0])
        #print (y_pr)
        tmp=(mapingClass[y_pred[0]])
        if(tmp<=a):
            print("b min ")
            b-=1
        else:
            print ("a up")
            a+=1

        count+=1    
        #print(a)
        #print (y_pred)
        #print (X_train)
        #print (X_test.shape)
        #print (y_pred.shape)

        #data=np.column_stack((x_test,y_pred))
        #print (dataZ['0-1'])
        #print (np.arriay2string(dataZ["0-4"], max_line_width=np.inf))
        #print (data);
print(confusion_matrix(y_tests,y_pr))  
#print(classification_report(y_test,y_pred))  
#print(y_tests)
#print(y_pr)
