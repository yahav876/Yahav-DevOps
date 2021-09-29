import xlrd
import csv

def csv_from_excel():
    wb = xlrd.open_workbook('/home/yahav/Downloads/Resource groups - 13.9.2021.xlsx')
    sh = wb.sheet_by_name('Main')
    your_csv_file = open('/home/yahav/Downloads/Resource groups - 13.9.2021.xlsx.csv', 'w')
    wr = csv.writer(your_csv_file, quoting=csv.QUOTE_ALL)

    for rownum in range(sh.nrows):
        wr.writerow(sh.row_values(rownum))

    your_csv_file.close()

# runs the csv_from_excel function:
csv_from_excel()