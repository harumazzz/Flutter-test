#pragma once

#include <iostream>
#include <cmath>

#if _WIN32
#define M_EXPORT_API extern "C" __declspec(dllexport)
#else
#define M_EXPORT_API extern "C" __attribute__((visibility("default")))
#endif

struct Input {

	double a;

	double b;

	double c;

};

struct Output {

	double x1;

	double x2;

};