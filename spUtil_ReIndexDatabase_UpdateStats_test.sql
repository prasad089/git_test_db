/****** Object:  StoredProcedure [dbo].[spUtil_ReIndexDatabase_UpdateStats]    Script Date: 11/19/2018 4:33:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[spUtil_ReIndexDatabase_UpdateStats]
AS
    EXEC ReBuild_Index
	DECLARE @MyTable VARCHAR(255)
	DECLARE myCursor
	CURSOR FOR
	SELECT table_name
	FROM 
		information_schema.tables
	WHERE 
		table_type = 'base table'
		
	OPEN myCursor
	FETCH NEXT
	FROM myCursor INTO @MyTable
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Update statistics:  ' + @MyTable
		--DBCC DBREINDEX(@MyTable, '', 80)
		exec('update statistics [' + @MyTable + ']')
		
		--INSERT INTO IndexLog(TableName) SELECT @MyTable
		
		FETCH NEXT FROM myCursor INTO @MyTable
	END
	CLOSE myCursor
	DEALLOCATE myCursor
	EXEC sp_updatestats

