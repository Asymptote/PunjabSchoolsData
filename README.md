# PunjabSchoolsData
Analysis of Punjab Schools Data (http://open.punjab.gov.pk/schools/)


# Getting the Data
### parser.R
Parses the Data of school visits for one tehsil (for current month).  

**For Example:**
In case you want to get data of tehsil **LAHORE CANTT**  
Go to -> http://open.punjab.gov.pk/schools/home/heat_map & Click Lahore District  
In next screen, copy url of LAHORE CANTT tehsil which is:
http://open.punjab.gov.pk/schools/dashboard/district_teacher_chart/MTc=/Njc=?fromDate=2015-05-1&toDate=2015-05-31&school_level=  
Change ***url*** variable in parser.R script.  