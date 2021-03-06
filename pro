from random import randrange
from csv import reader
from math import sqrt
import matplotlib.pyplot as plt
import numpy as np
def train_test_split(dataset, split):
	train = list()
	copy = dataset
	while len(train) < split * len(dataset):
		index = (len(copy))-1
		train.append(copy.pop(index))
	return train,copy
def rmse_metric(actual, predicted):
	sum_error = 0.0
	for i in range(len(actual)):
		error = predicted[i] - actual[i]
		sum_error += (error ** 2)
	mean_error = sum_error/len(actual)
	return sqrt(mean_error)
def evaluate_algorithm(dataset, split):
	train, test = train_test_split(dataset, split)
	test_set = list()
	for row in test:
		test_set.append(list(row))
	predictions = list()
	b0, b1 = coefficients(train)
	x = np.linspace(-5,5,100)
	y = b1*x+b0
	plt.plot(x, y, '-r', label='')
	plt.title('Graph')
	plt.xlabel('x', color='#1C2833')
	plt.ylabel('y', color='#1C2833')
	plt.legend(loc='upper left')
	plt.grid()
	plt.show()
	for row in test:
		yhat = b0 + b1 * row[0]
		predictions.append(yhat)
	actual = [row[1] for row in test]
	r = rmse_metric(actual, predictions)
	return r
def mean(values):
	return sum(values) / float(len(values))

def covariance(x, mean_x, y, mean_y):
	covar = 0.0
	for i in range(len(x)):
		covar += (x[i] - mean_x) * (y[i] - mean_y)
	return covar
def variance(values, mean):
	return sum([(x-mean)**2 for x in values])

def coefficients(dataset):
	x = [row[0] for row in dataset]
	y = [row[1] for row in dataset]
	x_mean, y_mean = mean(x), mean(y)
	b1 = covariance(x, x_mean, y, y_mean) / variance(x, x_mean)
	b0 = y_mean - b1 * x_mean
	return [b0, b1]

dataset = list()
with open('sabya.csv', 'r') as file:
	csv_reader = reader(file)
	for row in csv_reader:
		if not row:
			continue
		dataset.append(row)
for i in range(len(dataset[0])):
	for row in dataset:
		row[i] = float(row[i])
split = 0.6
rmse = evaluate_algorithm(dataset, split)

print('RMSE: %.3f' % (rmse))
