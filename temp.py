import math
import pandas as pd
import psycopg2
import getpass
import numpy as np
import tensorflow as tf
from sklearn.preprocessing import MinMaxScaler, StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, f1_score, recall_score, precision_score
from keras.models import Model, Sequential
from keras.layers import Dense, LeakyReLU
import matplotlib.pyplot as plt

path = 'dataset/dataset_sepsis.csv'
sepsis_dataset = pd.read_csv(path)

columns = list(sepsis_dataset.iloc[:,6:-2].columns)
Y = sepsis_dataset.iloc[:,3]
val=1
while(val >= 0.9):
  for col in columns:
    cols = columns.copy()
    cols.remove(col)
    X = sepsis_dataset[cols]
    X = MinMaxScaler().fit_transform(X.values)
    x_train, x_test, y_train, y_test = train_test_split(X,Y,test_size=0.3)
    model = Sequential()
    model.add(Dense(units=128,input_shape=(len(cols),),activation='relu'))
    model.add(Dense(units=64,activation='relu'))
    model.add(Dense(units=16,activation='relu'))
    model.add(Dense(units=4,activation='relu'))
    model.add(Dense(units=1,activation='sigmoid'))
    model.compile(optimizer='adam',loss='binary_crossentropy',metrics=['accuracy'])
    history = model.fit(x=x_train,y=y_train,validation_data=(x_test,y_test),epochs=2,verbose=0)
    acc = history.history['val_accuracy'][-1]
    if acc >= val:
      val = acc
      remove_col = col
    print("--",end="")
  print(">",end="\n")
  columns = columns.remove(remove_col)
  print("removed :"+remove_col,end="\n")