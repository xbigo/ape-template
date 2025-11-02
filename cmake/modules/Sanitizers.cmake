# Sanitizers.cmake
# Enable various sanitizers for debugging

if(APE2_ENABLE_SANITIZERS)
    if(MSVC)
        # MSVC only supports AddressSanitizer
        if(APE2_SANITIZER_TYPE STREQUAL "address")
            add_compile_options(/fsanitize=address)
            message(STATUS "AddressSanitizer enabled (MSVC)")
        else()
            message(WARNING "MSVC only supports AddressSanitizer. Requested: ${APE2_SANITIZER_TYPE}")
        endif()

    elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(SANITIZER_FLAGS "")

        if(APE2_SANITIZER_TYPE STREQUAL "address")
            set(SANITIZER_FLAGS "-fsanitize=address -fno-omit-frame-pointer")
            message(STATUS "AddressSanitizer enabled")

        elseif(APE2_SANITIZER_TYPE STREQUAL "memory")
            if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
                set(SANITIZER_FLAGS "-fsanitize=memory -fno-omit-frame-pointer -fsanitize-memory-track-origins")
                message(STATUS "MemorySanitizer enabled")
            else()
                message(WARNING "MemorySanitizer is only available with Clang")
            endif()

        elseif(APE2_SANITIZER_TYPE STREQUAL "thread")
            set(SANITIZER_FLAGS "-fsanitize=thread")
            message(STATUS "ThreadSanitizer enabled")

        elseif(APE2_SANITIZER_TYPE STREQUAL "undefined")
            set(SANITIZER_FLAGS "-fsanitize=undefined -fno-omit-frame-pointer")
            message(STATUS "UndefinedBehaviorSanitizer enabled")

        elseif(APE2_SANITIZER_TYPE STREQUAL "leak")
            set(SANITIZER_FLAGS "-fsanitize=leak")
            message(STATUS "LeakSanitizer enabled")

        else()
            message(WARNING "Unknown sanitizer type: ${APE2_SANITIZER_TYPE}")
        endif()

        if(SANITIZER_FLAGS)
            add_compile_options(${SANITIZER_FLAGS})
            add_link_options(${SANITIZER_FLAGS})
        endif()
    endif()
endif()

