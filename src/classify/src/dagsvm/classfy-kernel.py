import pandas as pd  
import numpy as np  
import matplotlib.pyplot as plt  
from sklearn.model_selection import train_test_split  
from sklearn.svm import SVC  
from sklearn.metrics import classification_report, confusion_matrix  


bankdata = pd.read_csv("../../data/data-temp.csv")  
#bankdata.shape  
#bankdata.head()
#bankdata.plot()
#plt.show()

X = bankdata.drop('class', axis=1)
y = bankdata['class']  

#X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.20)  
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, stratify=y, random_state=1) 

#svclassifier = SVC(kernel='poly', degree=30)
#svclassifier.fit(X_train, y_train)
#svclassifier = SVC(kernel='rbf')  
#svclassifier.fit(X_train, y_train)  
svclassifier = SVC(kernel='sigmoid')  
svclassifier.fit(X_train, y_train)


y_pred = svclassifier.predict(X_test)  
#print (y_pred)
print(confusion_matrix(y_test,y_pred))  
print(classification_report(y_test,y_pred))  
