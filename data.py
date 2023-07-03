import gspread
import sys
from oauth2client.service_account import ServiceAccountCredentials
scope = ["https://spreadsheets.google.com/feeds",'https://www.googleapis.com/auth/spreadsheets',"https://www.googleapis.com/auth/drive.file","https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name("ubunubun.json", scope)
client = gspread.authorize(creds)
sheet = client.open("ubunubun").sheet1 
data=sheet.get_all_values()
#print(data[3][0])
def ip():
	print(sheet.cell(2,1).value)
#	return sheet.cell(2,1).value
def username():
	print(sheet.cell(2,2).value)
def password():
	print(sheet.cell(2,3).value)
def check(user,pass_):
#	print(user,pass_)
	for i in range(3,len(data)):
		if data[i][0]==user:
			if sys.argv[1]=='s':
				if data[i][1]==pass_:
					print(1)
					break
			print(0)
			break
		
	else:
		if sys.argv[1]=='a':
			sheet.insert_row([user,pass_],len(data)+1)
			print(1)
		else:
			print(0)

if sys.argv[1]=='a' or sys.argv[1]=='s':
	check(sys.argv[2],sys.argv[3])
if sys.argv[1]=='ip':
	ip()
if sys.argv[1]=='username':
	username()
if sys.argv[1]=='password':
	password()
