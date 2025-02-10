**CPU Architecture**

The CPU (Central Processing Unit) is main block of the chip. In order to understanf what exactly it is for understanding here are few link and couses for exploring which gibes more insights. 

Generally we all know following stuff which we have read in college : 
The different ISA avaliable are : 
1. Intel X86 Architecture : CISC Machine.
2. ARM (v7, v8 and v9)    : RISC Machine.
   Designing the Hardware for RISC machine is very easy becuase the ISA is simple when comapred to CISC machine. 
3. RISC-V
4. Power PC

**Chip Design : **
For any chip to work we have three components that plays a major impact i.e., OS (Operating System), Compiler and Hardware ISA. 
Image : ![image](https://github.com/user-attachments/assets/52200fa9-9ff8-4b05-99e0-1b9db6927e0a)

From 1980 onwards there is large growth in the Semiconductor field from Tranistor level, Block level, Subsystem level or Core level, Mulitcore Architecture, Parallel Architecture. 
The Chips are used everywhere ranging from Toys, Mobiles, PC, Laptops, Automotive and Space. Varying Applications from small to big everyting uses Chips inside. 
Based on application we have Microprocessor and Microcontroller avaialable. So, on based application we choose the chips.
Image : 
![image](https://github.com/user-attachments/assets/f32dba68-ccaf-46dc-b305-4a3828c6fc7f)

Source Image : https://github.com/arm-university/Fundamentals-of-System-on-Chip-Design-on-Arm-Cortex-M-Microcontrollers

For further understanding refer these amazing course which give much depth insights. I recommeded to read the ARM SoC books which gives perfect understanding of the Chip for ELectronics, VLSI, Embedded System students. 
These gives basic to advanced understanding about chip.

**Course Link :** 
1. Verilog                          : In this course will explain the HDL language for defining Hardware. Nowdays we have HLS tools (C/C++ to RTL/HDL Conversion) . Link : https://onlinecourses-archive.nptel.ac.in/noc18_cs48/preview#:~:text=The%20course%20will%20introduce%20the%20participants%20to%20the,Important%20For%20Certification%2FCredit%20Transfer%3A%20Note%3A%20Content%20is%20Free%21
2. Computer Architecture            : Introductory computer architecture course for beginners. Link : https://onlinecourses.nptel.ac.in/noc23_cs67/preview.
3. Advanced Computer Architecture   : In this course we will discuss the OOO Pipeline, Memory (Cache design, Main Memory and Secondary storage), GPU and avanced Hardware for AI/ML applications. Link : https://onlinecourses.nptel.ac.in/noc23_cs07/preview#:~:text=About%20the%20course%3A%20This%20course%20is%20on%20Advanced,pipelines%2C%20GPUs%2C%20and%20compiler%20techniques%20for%20enhancing%20ILP.
4. Parallel Computer Architecture   : In this course we will discuss the need of Parallel computations, Cache design and coherence design, Interconnect Design .Link : https://onlinecourses.nptel.ac.in/noc24_cs63/preview
5. Multicore Architecture           : In this course Advanced understanding of the concepts Computer, GPU, Memory (Cache, DRAM), Interconnect NoC. https://onlinecourses.nptel.ac.in/noc23_cs113/preview#:~:text=This%20course%20will%20focus%20on%20delivering%20an%20in-depth,DRAM%20systems%2C%20on%20chip%20interconnects%20and%20domain%20specifi
6. ARM Cortex A72 Documentation     : Most of the time many of use ARM IP's. Based on the application we have three profiles A - Application, R - Real time and M - Microcontroller. Generally we refer ARM : Advanced RISC Machine.
7. SoC Books
   - https://github.com/arm-university/Fundamentals-of-System-on-Chip-Design-on-Arm-Cortex-M-Microcontrollers
   - https://github.com/arm-university/Modern-System-on-Chip-Design-on-Arm or https://www.arm.com/resources/education/books/modern-soc
   - https://www.arm.com/resources/education/online-courses/introduction-to-soc
   - Resorces Link : https://www.arm.com/resources/education/
8. The CPU Architecture and System Architecture resemble almost same. We extract the concepts from CPU and apply to System level.
   Link : https://www.arm.com/architecture/system-architectures.
9. Multithreading or Threading Mapping to Hardware. Generally we have heard what is Threading, Multi-THreading and Hyperthreading. How exactly is mapped in Hardware? The following papers gibes insights on this : 
   Link :
   - https://www.cs.ucr.edu/~bhuyan/cs203A/hyperthreading.pdf
   - https://www.cs.ucr.edu/~bhuyan/cs162/LECTURE10.pdf

**ARM Cortex A72**
It is recommeded to read or know the ARM Core. See the below documents to know what exaclty the components are found in CPU. Read the section we get more Real time application data. 
Link : https://developer.arm.com/documentation/102530/0002/The-Cortex-A720--core 

CPU Core Image : 
![image](https://github.com/user-attachments/assets/615977ca-be6e-478b-a6db-68eab7dce6b9)

Link : https://developer.arm.com/documentation/102530/0002/Technical-overview/Core-components
Based on the Application ARM provides different IP Cores and customized ones. 

**NOTE : Why ARM Popularity ? **
Image : 
![image](https://github.com/user-attachments/assets/f32dba68-ccaf-46dc-b305-4a3828c6fc7f)

Source Image : https://github.com/arm-university/Fundamentals-of-System-on-Chip-Design-on-Arm-Cortex-M-Microcontrollers








