########################################################
# core.pyx
# Author: Jamie Zhu <jimzhu@GitHub>
# Created: 2014/2/6
# Last updated: 2015/7/30
########################################################

import time
import numpy as np
from utilities import *
cimport numpy as np # import C-API
from libcpp cimport bool


#########################################################
# Make declarations on functions from cpp file
#
cdef extern from "AMF.h":
    void AMF(double *removedData, int numUser, int numService, 
        int dim, double lmda, int maxIter, double eta, double beta, 
        bool debugMode, double *Udata, double *Sdata, double *predData)
#########################################################


#########################################################
# Function to perform the prediction algorithm
# Wrap up the C++ implementation
#
def predict(removedMatrix, U, S, para):  
    cdef int numService = removedMatrix.shape[1] 
    cdef int numUser = removedMatrix.shape[0] 
    cdef int dim = para['dimension']
    cdef double lmda = para['lambda']
    cdef int maxIter = para['maxIter']
    cdef double eta = para['eta']
    cdef double beta = para['beta']
    cdef bool debugMode = para['debugMode']
    cdef np.ndarray[double, ndim=2, mode='c'] predMatrix = \
        np.zeros((numUser, numService), dtype=np.float64)
    
    logger.info('Iterating...')

    # wrap up AMF.cpp
    AMF(
        <double *> (<np.ndarray[double, ndim=2, mode='c']> removedMatrix).data,
        numUser,
        numService,
        dim,
        lmda,
        maxIter,
        eta,
        beta,
        debugMode,
        <double *> (<np.ndarray[double, ndim=2, mode='c']> U).data,
        <double *> (<np.ndarray[double, ndim=2, mode='c']> S).data,
        <double *> predMatrix.data
        )

    return predMatrix
#########################################################




