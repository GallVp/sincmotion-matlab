/*
 * wt_helpers.c
 *
 *  Created on: April 7, 2020
 *      Author: Usman Rashid
 */

#include "mex.h"
#include "diff_cwtft.h"
#include "wavelib.h"
#include <stdio.h>
#include <math.h>


void diff_cwtft(double* t_in_signal, double* t_out_signal, int t_signal_length, double t_scale, double t_dt) {

	// CWT parameters
	char* wave 			= "dog";
	char* type 			= "pow";

	double wav_param 	= 1.0;
	double dj 			= 0; 						// Scale step
    double wav_dt       = 1.0;
	int total_scales 	= 1; 						// Total Number of scales
	int pow_param 		= 1;						// Power 

	// Initialise cwt
	cwt_object wt;
	wt 					= cwt_init(wave, wav_param, t_signal_length, wav_dt, total_scales);

	// Set cwt parameters
	setCWTScales(wt, t_scale, dj, type, pow_param);

	cwt(wt, t_in_signal);

	// Scale and copy to output array 
	int i;

	// double multiplier= (-1 / t_dt) / pow(t_scale, 3.0/2.0) / pow(2.0*PI, 1.0/4.0);
	double multiplier	= (-1.0 / t_dt) / pow(t_scale, 3.0/2.0) / pow(2.0*PI, 1.0/4.0);

	for (i = 0; i < t_signal_length; ++i) {
		t_out_signal[i] 	= wt->output[i].re * multiplier;
	}

	// Free resources
	cwt_free(wt);
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    
    double* in_signal;
    double scale;
    double dt;
    
    int signal_length;
    double* out_signal;
    
    size_t ncols;
    
    /* check for proper number of arguments */
    if(nrhs!=3) {
        mexErrMsgIdAndTxt("wavelib:wt_helpers:nrhs","Three inputs required.");
    }
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("wavelib:wt_helpers:nlhs","One output required.");
    }
    
    scale = mxGetScalar(prhs[1]);
    dt = mxGetScalar(prhs[2]);
    
    /* create a pointer to the real data in the input matrix  */
#if MX_HAS_INTERLEAVED_COMPLEX
    in_signal = mxGetDoubles(prhs[0]);
#else
    in_signal = mxGetPr(prhs[0]);
#endif
    
    /* get dimensions of the input matrix */
    ncols = mxGetN(prhs[0]);
    signal_length = (int)ncols;
    
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(1,(mwSize)ncols,mxREAL);
    
    /* get a pointer to the real data in the output matrix */
#if MX_HAS_INTERLEAVED_COMPLEX
    out_signal = mxGetDoubles(plhs[0]);
#else
    out_signal = mxGetPr(plhs[0]);
#endif
    
    diff_cwtft(in_signal, out_signal, signal_length, scale, dt);
}

