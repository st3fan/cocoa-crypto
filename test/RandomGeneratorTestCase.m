
#import <Foundation/Foundation.h>
#import "RandomGenerator.h"

int main()
{
   NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
   {
      RandomGenerator* random = [RandomGenerator randomGenerator];
      for (int i = 0; i < 100; i++) {
         NSLog(@"%d", [random randomLong]);
      }
   }
   [pool release];

   return 0;
}
