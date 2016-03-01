//
//  NSFileManager+Size.m
//  SNArchitecture
//


#import "NSFileManager+Size.h"
#include <sys/stat.h>
#include <dirent.h>

@implementation NSFileManager (Size)

+ (unsigned long long)fileSizeAtPath:(NSString *)filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0)
    {
        return st.st_size;
    }
    
    return 0;
}

unsigned long long dirSizeAtPath(const char* dirPath)
{
    unsigned long long dirSize = 0;
    DIR* dir = opendir(dirPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir)) != NULL)
    {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) ||
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)
                                        )) continue;
        
        int dirPathLength = strlen(dirPath);
        char childPath[1024];
        stpcpy(childPath, dirPath);
        if (dirPath[dirPathLength-1] != '/')
        {
            childPath[dirPathLength] = '/';
            dirPathLength++;
        }
        stpcpy(childPath+dirPathLength, child->d_name);
        childPath[dirPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR)
        {
            dirSize += dirSizeAtPath(childPath);
            struct stat st;
            if(lstat(childPath, &st) == 0) dirSize += st.st_size;
        }
        else if (child->d_type == DT_REG || child->d_type == DT_LNK)
        {
            struct stat st;
            if(lstat(childPath, &st) == 0) dirSize += st.st_size;
        }
    }
    
    return dirSize;
}

+ (unsigned long long)directorySizeAtPath:(NSString *)directoryPath
{
    return dirSizeAtPath([directoryPath cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
