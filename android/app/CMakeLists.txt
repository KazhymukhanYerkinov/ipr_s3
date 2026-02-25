cmake_minimum_required(VERSION 3.10)
project(hash_utils LANGUAGES C)

add_library(hash_utils SHARED
    ../../native/src/hash_utils.c
)
