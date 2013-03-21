SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- validate stored proc
create procedure [dbo].[CheckPassword]
   @user varchar(200)
 , @password varchar(200)
as
if hashbytes('SHA2_512', @password) = (select passwordhash 
                                 from UserTest
								 where firstname = @user
								)
  select 'Password Match'
else
  select 'Password Fail'
  ;
return
GO
