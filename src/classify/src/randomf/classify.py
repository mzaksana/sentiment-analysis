import pandas as pd  
import numpy as np  
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestRegressor
from sklearn import metrics
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score


dataset = pd.read_csv('../../../../data/data-set/train.csv')  
dataset.head()  

X_train = dataset.drop('class', axis=1) 
y_train = dataset['class']  
y_train=y_train.replace('one',value= 0)
y_train=y_train.replace(regex='two',value= 1)
y_train=y_train.replace(regex='three',value= 2)
y_train=y_train.replace(regex='four',value= 3)
y_train=y_train.replace(regex='five',value= 4)


data_test=pd.read_csv("../../../../data/data-set/test.csv")
X_test=data_test.drop('class', axis=1)  
y_test = data_test['class']
y_test=y_test.replace('one', 0)
y_test=y_test.replace('two', 1)
y_test=y_test.replace('three', 2)
y_test=y_test.replace('four', 3)
y_test=y_test.replace('five', 4)


sc = StandardScaler()  
X_train = sc.fit_transform(X_train)  
X_test = sc.transform(X_test)

# print(y_test)

regressor = RandomForestRegressor(n_estimators=20, random_state=0)  
regressor.fit(X_train, y_train)  
y_pred = regressor.predict(X_test)


print('Mean Absolute Error:', metrics.mean_absolute_error(y_test, y_pred))  
print('Mean Squared Error:', metrics.mean_squared_error(y_test, y_pred))  
print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(y_test, y_pred)))

# print(y_test)
y_ts=[]

for val in y_test:
    y_ts.append(val)

# print(y_ts)
y_pred=pd.cut(y_pred,bins=5,labels=np.arange(5),right=False)
# print(aa)
print(confusion_matrix(y_ts,y_pred))  
print(classification_report(y_test,y_pred))  
print(accuracy_score(y_test, y_pred, normalize=False)) 