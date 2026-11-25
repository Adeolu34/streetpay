with open('streetpay/lib/newhome/newhome_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('Icons.arrow_downward_rounded', 'Icons.north_east_rounded')
content = content.replace("'Withdraw'", "'Transfer'")

with open('streetpay/lib/newhome/newhome_widget.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('Updated newhome_widget successfully!')
