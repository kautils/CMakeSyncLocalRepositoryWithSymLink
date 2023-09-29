
macro(CMakeSyncLocalRepositoryWithSymLink )
    set(${PROJECT_NAME}_m_evacu ${m})
    set(m ${PROJECT_NAME}.CMakePullLocalRepositoryAsSymLink)
    cmake_parse_arguments(${m} "VERBOSE" "LOCAL;DESTINATION" "REPOS" ${ARGV} )
    
    macro(CMakePullLocalRepositoryAsSymLink_pull_local __arg0 __arg1 __dest_root)
        set(${PROJECT_NAME}_m_evacu ${m})
        set(m ${m}_pull_local)
        set(${m}_unsetter __dest)
        get_filename_component(${m}_name "${__arg1}" NAME)
        set(__dest "${__dest_root}/${${m}_name}" )
        
        if(${__arg0} STREQUAL "ON")
            if(NOT EXISTS ${__dest})
                file(CREATE_LINK ${__arg1} "${__dest}" SYMBOLIC)
            endif()
            if(EXISTS "${__dest}/CMakeLists.txt")
                add_subdirectory(${__dest})
            endif()
        else()
            if(IS_SYMLINK ${__dest})
                file(REMOVE ${__dest})
            endif()
        endif()

        foreach(__v ${${m}_unsetter})
            unset(${__v})
        endforeach()
        unset(${m}_unsetter)
        set(m ${${PROJECT_NAME}_m_evacu})
    endmacro()

    
    
    list(APPEND ${m}_unsetter ${m}_want ${m}_REPOS ${m}_VERBOSE ${m}_LOCAL)
    list(APPEND ${m}_unsetter ${m}_want ${m}_verbose ${m}_syms ${m}_repo_name ${m}_local ${m}_repos ${m}_found_key ${m}_dest)
    set(${m}_want ${${m}_REPOS})
    set(${m}_verbose ${${m}_VERBOSE})
    set(${m}_local "${${m}_LOCAL}")
    file(GLOB ${m}_repos ${${m}_local}/*)
    set(${m}_found_key ":found:")
    set(${m}_dest ${CMAKE_CURRENT_SOURCE_DIR}/${${m}_name})
    
    if(${m}_verbose)
        include(CMakePrintHelpers)
        cmake_print_variables(${m}_want)
        cmake_print_variables(${m}_local)
        cmake_print_variables(${m}_repos)
    endif()
    
        
    foreach(repo ${${m}_repos})
        get_filename_component( ${m}_repo_name "${repo}" NAME)
        list(APPEND ${m}_unsetter ${m}_sym_${${m}_repo_name} ${m}_sym_${${m}_repo_name}.found)
        list(APPEND ${m}_syms ${m}_sym_${${m}_repo_name})
        
        
        foreach(w ${${m}_want})
            if(NOT DEFINED ${m}_sym_${${m}_repo_name})
                set(${m}_sym_${${m}_repo_name} "${repo}")
            endif()
            if("${w}" STREQUAL "${${m}_repo_name}")
                set(${m}_sym_${${m}_repo_name}.found "${${m}_found_key}")
                CMakePullLocalRepositoryAsSymLink_pull_local(ON "${repo}" "${${m}_dest}")
                break()
            endif()
        endforeach()
    endforeach()
    
    foreach(s ${${m}_syms})
        if(NOT ${${s}.found} STREQUAL "${${m}_found_key}")
            CMakePullLocalRepositoryAsSymLink_pull_local(OFF "${${s}}" "${${m}_dest}")
        endif()
    endforeach()
    
    foreach(w ${${m}_want})
        if(NOT DEFINED ${m}_sym_${w})
            message(WARNING "fail to found \"${${w}}\" in ${${m}_local}" )
        endif()
    endforeach()
    
    
    foreach(__v ${${m}_unsetter})
        unset(${__v})
    endforeach()
    unset(${m}_unsetter)
    set(m ${${PROJECT_NAME}_m_evacu})
    
endmacro()

