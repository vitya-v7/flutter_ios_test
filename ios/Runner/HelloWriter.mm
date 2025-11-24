//
//  HelloWriter.mm
//  Runner
//
//  Created by X on 24.11.2025.
//

#import "HelloWriter.h"
#include <stdio.h>
#include <fstream>
#include <string>

bool write_hello_line(const char *path, int n, bool append) {
    if (path == nullptr) {
        return false;
    }

    std::ios_base::openmode mode = std::ios::out;
    if (append) {
        mode |= std::ios::app;
    }

    std::ofstream file(path, mode);
    if (!file.is_open()) {
        return false;
    }

    file << "hello world " << n << "\n";
    return true;
}
