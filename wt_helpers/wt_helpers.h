/*
 * wt_helpers.h
 *
 *  Created on: April 7, 2020
 *      Author: Usman Rashid
 */

#ifndef WT_HELPERS_H_
#define WT_HELPERS_H_


#ifdef __cplusplus
extern "C" {
#endif

#define PI 3.14159265358979323846

void diff_cwtft(double* t_in_signal, double* t_out_signal, int t_signal_length, double t_scale, double t_dt);

#ifdef __cplusplus
}
#endif

#endif
