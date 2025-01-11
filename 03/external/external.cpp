#include "external.h"

template <typename T>
using Pointer = T*;

M_EXPORT_API
auto solve(
    Pointer<Input> input,
    Pointer<Output> output
) -> int
{
    auto a = input->a;
    auto b = input->b;
    auto c = input->c;
    if (a == 0) {
        if (b == 0) {
            if (c == 0) {
                // Vô số nghiệm
                return -1;
            }
            else {
                // Vô nghiệm
                return 0;
            }
        }
        else {
            auto result = - c / b;
            output->x1 = result;
            output->x2 = result;
            // có 1 nghiệm duy nhất
            return 1;
        }
    }
    auto delta = b * b - 4 * a * c;
    if (delta < 0) {
        // Vô nghiệm
        return 0;
    }
    else if (delta == 0) {
        auto result = -b / (2 * a);
        output->x1 = result;
        output->x2 = result;
        // Nghiệm kép
        return 2;
    }
    else {
        auto x1 = (-b + std::sqrt(delta)) / (2 * a);
        auto x2 = (-b - std::sqrt(delta)) / (2 * a);
        output->x1 = x1;
        output->x2 = x2;
        // 2 nghiệm
        return 3;
    }
}