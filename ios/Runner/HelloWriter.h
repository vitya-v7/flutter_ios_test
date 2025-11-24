//
//  HelloWriter.h
//  Runner
//
//  Created by X on 24.11.2025.
//

#pragma once
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Записывает строку "hello world N" в файл
bool write_hello_line(const char *path, int n, bool append);

#ifdef __cplusplus
}

#endif
