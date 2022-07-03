
--- Assignment-5 ---

-- Create a scalar-valued function that returns the factorial of a number you gave it.


CREATE FUNCTION dbo.factorial
(
	@input INT
)
RETURNS INT
AS
BEGIN
	DECLARE @fact INT = 1
	WHILE @input > 1
		BEGIN
		SET @fact = @input * @fact
		SET @input = @input - 1
		END
	RETURN @fact
END
;

SELECT dbo.factorial(10) as Factorial_of_Number

























