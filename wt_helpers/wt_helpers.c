/*
 * wt_helpers.c
 *
 *  Created on: April 7, 2020
 *      Author: Usman Rashid
 */

#include "wt_helpers.h"
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
