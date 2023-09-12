### CMakeSyncLocalRepositoryWithSymLink
* sync local repository using symlink

### note 
* if directory has CMakeLists.txt, then automatically do add_subdirectory(...)

### example
```cmake

include(CMakeSyncLocalRepositoryWithSymLink.cmake)

CMakeSyncLocalRepositoryWithSymLink(
    LOCAL "path_to_local_repository_root"
    REPOS 
        directory_name_0
        directory_name_1
        directory_name_2
    DESTINATION "path_to_destination"
)

# directory_name_1 will automatically removed
CMakeSyncLocalRepositoryWithSymLink(
    LOCAL "path_to_local_repository_root"
    REPOS 
        directory_name_0
        directory_name_2
    DESTINATION "path_to_destination"
)

```