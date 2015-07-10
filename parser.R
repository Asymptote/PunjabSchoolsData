library(rvest)
library(XML)

#This url is for SHEIKHUPURA(District) => SHARAQPUR(Tehsil)
url <- "http://open.punjab.gov.pk/schools/dashboard/district_teacher_chart/MzM=/MTE1?fromDate=2015-05-1&toDate=2015-05-31&school_level="

#Construct Dataframe: Get Biggest table as data frame
tables <- readHTMLTable(url)
n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))
df <- tables[[which.max(n.rows)]]

#Extract links of school_visit_details
#For each name of school anchor tag and href
page<-htmlParse(url)
for (i in 1:dim(df)[1]) {
  name <- as.character(df[i,2])
  
  regexp <- paste0('//a[text()=\'',name,'\']/@href')
  df$DetailsLink[i] <- xpathSApply( page, regexp)
}

#Rename header or names
names(df) <- c("Code", "Name", "Visits", "LastVisitDateTime", "TeacherPresence", "DetailsLink")
rm(n.rows, page, tables, url)

#------------------------------------------------------------------------------------


df$TotalTeachers <- rep(0,dim(df)[1])
df$PresentTeachers <- rep(0,dim(df)[1])
df$AbsentTeachers <- rep(0,dim(df)[1])
df$TotalEnrolledStudents <- rep(0,dim(df)[1])
df$NumberOfClasses <- rep(0,dim(df)[1])
df$TotalClassrooms <- rep(0,dim(df)[1])
df$UsedClassrooms <- rep(0,dim(df)[1])

for (i in 1:dim(df)[1]) {
  print(i)
  detailUrl <- df$DetailsLink[i]
  
  #--------------------------------------
  #url <- "http://open.punjab.gov.pk/schools/home/school_visit_detail/521164"
  page<-htmlParse(detailUrl)
  teach <- xpathSApply( page, "//table[contains(.,'Presence Of Teaching Staff')]",xmlValue)
  teachList <- strsplit(teach, "\r\n\\W+")[[1]]
  
  df$TotalTeachers[i] <- as.numeric(teachList[7])   #Store
  df$PresentTeachers[i] <- as.numeric(teachList[8]) #Store
  df$AbsentTeachers[i] <- as.numeric(teachList[9])  #Store
  
  rm(teach)
  rm(teachList)
  
  #------------
  stu <- xpathSApply( page, "//tr[contains(.,'No. of Students Enrolled ')]//td",xmlValue)
  
  df$TotalEnrolledStudents[i] <- as.numeric(stu[16])      #Store
  classesVec <- as.numeric(stu[c(-1,-16)])
  df$NumberOfClasses[i] <- length(which(classesVec != 0)) #Store
  
  rm(stu)
  rm(classesVec)
  
  #------------
  tc <- xpathSApply( page, "//td[contains(.,'Total no. of Classrooms:')]//span",xmlValue)
  
  df$TotalClassrooms[i] <- tc[1]  #Store
  df$UsedClassrooms[i] <- tc[2]   #Store
  
  rm(tc)
  
}

