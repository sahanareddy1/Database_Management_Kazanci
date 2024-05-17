# Anton De Franco 

set sql_mode='';
SHOW VARIABLES LIKE 'sql_mode';


#Find Top performing auditors based on CRITICAL Severity
SELECT 
    auditor.EMPLOYEEID,
    auditor.firstname,
    auditor.lastname,
    COUNT(finding.severity) AS CriticalFindings
FROM
    auditor
        JOIN
    auditor_report ON auditor.employeeid = auditor_report.employeeid
        JOIN
    audit_report ON auditor_report.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
        JOIN
    finding ON finding.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
WHERE
    finding.severity IN ('Kritik')
GROUP BY auditor.employeeID
ORDER BY CriticalFindings DESC;
-------------------------------------------------------------------------------------------------
#Find Top performing auditors based on HIGH Severity
SELECT 
    auditor.EMPLOYEEID,
    auditor.firstname,
    auditor.lastname,
    COUNT(finding.severity) AS CriticalFindings
FROM
    auditor
        JOIN
    auditor_report ON auditor.employeeid = auditor_report.employeeid
        JOIN
    audit_report ON auditor_report.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
        JOIN
    finding ON finding.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
WHERE
    finding.severity IN ('YÃ¼ksek' )
GROUP BY auditor.employeeID
ORDER BY CriticalFindings DESC;

---------------------------------------------------------------------------------------------------------------------

#Find Top performing auditors based on AVG Audit completion time
SELECT 
    auditor.firstname,
    auditor.lastname,
    avG(date(audit_report.AUDIT_END_DATE) - date(audit_report.AUDIT_START_DATE)) as avgEnd
FROM
    auditor
        JOIN
    auditor_report ON auditor.employeeid = auditor_report.employeeid
        JOIN
    audit_report ON auditor_report.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
        JOIN
    finding ON finding.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
GROUP BY auditor.FIRSTNAME, auditor.lastname
ORDER BY avgEnd asc;

---------------------------------------------------------------------------------------------------------------------

#Find severity (high and medium) based on sector

SELECT 
    audit_report.Sector,
    finding.severity,
	COUNT(finding.severity) AS CriticalFindings
FROM
    auditor
        JOIN
    auditor_report ON auditor.employeeid = auditor_report.employeeid
        JOIN
    audit_report ON auditor_report.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
        JOIN
    finding ON finding.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
WHERE
    finding.severity IN ('YÃ¼ksek','Kritik')
GROUP BY audit_report.Sector, severity
ORDER BY audit_report.Sector asc;

---------------------------------------------------------------------------------------------------------------------

#Find open audit count based on sector

SELECT 
    audit_report.Sector,
    finding.STATUS,
	COUNT(finding.STATUS) AS openFindings
FROM
    auditor
        JOIN
    auditor_report ON auditor.employeeid = auditor_report.employeeid
        JOIN
    audit_report ON auditor_report.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
        JOIN
    finding ON finding.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
WHERE
    finding.STATUS IN ('SÃ¼reÃ§ Sahibi YÃ¶neticisinin OnayÄ±nda Bekliyor','SÃ¼reÃ§ Sahibine Atanan Bulgu')
    and finding.severity in ('YÃ¼ksek','Kritik')
GROUP BY audit_report.sector, finding.STATUS
order by openFindings desc;

---------------------------------------------------------------------------------------------------------------------

SELECT 
    finding.STATUS,
    finding.severity,
	COUNT(finding.STATUS) AS openFindings
FROM
    auditor
        JOIN
    auditor_report ON auditor.employeeid = auditor_report.employeeid
        JOIN
    audit_report ON auditor_report.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
        JOIN
    finding ON finding.AUDIT_REPORT_NUMBER = audit_report.AUDIT_REPORT_NUMBER
WHERE
    finding.STATUS IN ('SÃ¼reÃ§ Sahibi YÃ¶neticisinin OnayÄ±nda Bekliyor','SÃ¼reÃ§ Sahibine Atanan Bulgu')
GROUP BY finding.severity, finding.status
order by openFindings desc;
------------------------------------------------------------------------------------------------------------------------
# Sahana Reddy 
#Find open audit count based on severity

  -- Most Commonly Used Processes 
    SELECT audit_process.processid, process.processname, COUNT(audit_process.processid) as Process_Count
    FROM audit_process
    LEFT JOIN process
		ON audit_process.processid = process.processid
    GROUP BY processid
    ORDER BY Process_Count DESC;
    
    -- Most commonly used sub-processes (Might be redundant)  
    SELECT sub_process.sub_process_id, sub_process.sub_process_name, sub_process.processid, COUNT(sub_process.sub_process_id) as Sub_Process_Count
    FROM audit_process
    LEFT JOIN process
		ON audit_process.processid = process.processid
    LEFT JOIN sub_process
		ON process.processid = sub_process.processid
    GROUP BY Sub_Process_id
    ORDER BY Sub_Process_Count DESC;
    
    -- Severity based on processes 
		-- Processes vs Count of Critical Severity
		SELECT 
			process.processid, process.processname,
			COUNT(finding.severity) as Critcal_Severity_Count
		FROM finding
		LEFT JOIN audit_process
			ON audit_process.audit_report_number = finding.audit_report_number
		JOIN process
			ON process.processid = audit_process.processid
		WHERE finding.severity = 'Kritik'
		GROUP BY process.processid
		ORDER BY Critcal_Severity_Count DESC;
    
		--  Processes vs Count of High Severity
		SELECT 
			process.processid, process.processname,
			COUNT(finding.severity) as High_Severity_Count
		FROM finding
		LEFT JOIN audit_process
			ON audit_process.audit_report_number = finding.audit_report_number
		JOIN process
			ON process.processid = audit_process.processid
		WHERE finding.severity = 'YÃ¼ksek'
		GROUP BY process.processid
		ORDER BY High_Severity_Count DESC;
        
        --  Processes vs Count of Medium Severity
        SELECT 
			process.processid, process.processname,
			COUNT(finding.severity) as Medium_Severity_Count
		FROM finding
		LEFT JOIN audit_process
			ON audit_process.audit_report_number = finding.audit_report_number
		JOIN process
			ON process.processid = audit_process.processid
		WHERE finding.severity = 'Orta'
		GROUP BY process.processid
		ORDER BY Medium_Severity_Count DESC;
        
         --  Processes vs Count of Low Severity
        SELECT 
			process.processid, process.processname,
			COUNT(finding.severity) as Low_Severity_Count
		FROM finding
		LEFT JOIN audit_process
			ON audit_process.audit_report_number = finding.audit_report_number
		JOIN process
			ON process.processid = audit_process.processid
		WHERE finding.severity = 'DÃ¼ÅŸÃ¼k'
		GROUP BY process.processid
		ORDER BY Low_Severity_Count DESC;
    
    
    -- Time Series-Severity
		-- Critical Severity by Year
		SELECT 
			Year(audit_report.audit_report_date) as Yr, 
			COUNT(finding.severity) as Critical_Severity_Count
		FROM audit_report
		JOIN finding
			ON audit_report.audit_report_number = finding.audit_report_number
		WHERE finding.severity = 'Kritik'
		GROUP BY Yr
		ORDER BY Yr DESC;
		
		-- High Severity by Year
		SELECT 
			Year(audit_report.audit_report_date) as Yr, 
			COUNT(finding.severity) as High_Severity_Count
		FROM audit_report
		JOIN finding
			ON audit_report.audit_report_number = finding.audit_report_number
		WHERE finding.severity = 'YÃ¼ksek'
		GROUP BY Yr
		ORDER BY Yr DESC;
		
		--  Medium Severity by Year
		SELECT 
			Year(audit_report.audit_report_date) as Yr, 
			COUNT(finding.severity) as Medium_Severity_Count
		FROM audit_report
		JOIN finding
			ON audit_report.audit_report_number = finding.audit_report_number
		WHERE finding.severity = 'Orta'
		GROUP BY Yr
		ORDER BY Yr DESC;
		
		-- Low Severity by Year
		SELECT 
			Year(audit_report.audit_report_date) as Yr, 
			COUNT(finding.severity) as Low_Severity_Count
		FROM audit_report
		JOIN finding
			ON audit_report.audit_report_number = finding.audit_report_number
		WHERE finding.severity =  'DÃ¼ÅŸÃ¼k'
		GROUP BY Yr
		ORDER BY Yr DESC;
        
        
#HARSHRAJ JADEJA


#Most common risk types coming from which sectors

SELECT
	a.RISK_TYPE,
    b.SECTOR,
    COUNT(*)
FROM 
	FINDING a
    INNER JOIN AUDIT_REPORT b
    ON a.AUDIT_REPORT_NUMBER = b.AUDIT_REPORT_NUMBER
GROUP BY 1,2;



#time spend on audit vs severity (avg days - severity)

SELECT
	a.SEVERITY,
    b.SECTOR,
    avg(DATEDIFF(b.AUDIT_END_DATE, b.AUDIT_START_DATE)) AS avg_days
FROM 
	FINDING a
    INNER JOIN AUDIT_REPORT b
    ON a.AUDIT_REPORT_NUMBER = b.AUDIT_REPORT_NUMBER
GROUP BY 1,2;


#return all audits that have more than 2 auditors (also check for the completion time for the same - see if its less than the ones with less auditors)

SELECT 
	a.AUDIT_REPORT_NUMBER,
    COUNT(DISTINCT a.EMPLOYEEID) AS Number_of_Auditors,
    DATEDIFF(b.AUDIT_END_DATE, b.AUDIT_START_DATE) AS num_days
FROM
	AUDITOR_REPORT a
    INNER JOIN AUDIT_REPORT b
    ON a.AUDIT_REPORT_NUMBER = b.AUDIT_REPORT_NUMBER
GROUP BY 1
having count(*)>2;


#number processes per audit

SELECT
	AUDIT_REPORT_NUMBER,
    COUNT(DISTINCT PROCESSID) as Number_of_Processes
FROM 
	AUDIT_PROCESS
GROUP BY 1;
    
WITH temp1 as 
(
	SELECT
		EmployeeID,
		Category,
		SUM(Working_hours) as Category_working_hr
	FROM
		TIMESHEET
	GROUP BY 1,2
),
temp2 as 
(
	SELECT
		EmployeeID,
        SUM(Working_hours) as Overall_working_hr
	FROM
		TIMESHEET
	GROUP BY 1
),
temp3 as
(
SELECT
	temp1.EmployeeID,
    a.FirstName,
    a.LastName,
	temp1.Category,
    (temp1.Category_working_hr / temp2.Overall_working_hr) * 100 as Percentage_Working_Hrs
FROM
	temp1 INNER JOIN temp2
    ON temp1.EmployeeID = temp2.EmployeeID
	LEFT JOIN Auditor a
    ON temp1.EmployeeID = a.EmployeeID
WHERE
	temp1.Category IN ("Ã–n HazÄ±rlÄ±k", "Ä°nceleme", "Rapor YazÄ±mÄ±")
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4
),
temp4 as
(
SELECT
Category,
    CONCAT((AVG(Percentage_Working_Hrs)), '%') as AVG_Percentage
FROM
	temp3
GROUP BY 1
)
SELECT
	temp3.EmployeeID,
    temp3.FirstName,
    temp3.LastName,
    temp3.Category,
    CONCAT((temp3.Percentage_Working_Hrs), '%'),
    temp4.AVG_Percentage
FROM
	temp3 
    LEFT JOIN temp4
    ON temp3.Category = temp4.Category;
    
    
