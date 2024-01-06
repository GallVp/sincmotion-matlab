%% Setup

clear
close all
clc

%% Constants
TEST_TOL                        = 1e-10;
FS                              = 100;
IS_ANDROID                      = 1;                % ANDROID=1, else IOS
SKIP_AT_RANDOM                  = 1;
SKIP_PERCENTAGE                 = 80;
rng shuffle

%% Validation data and outcomes
%
% TODO: To be added after publication of the data