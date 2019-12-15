RAM = list(range(0, 33))

r1 = 2
r0 = 2
while r0 < 32:
    r0 += 1
    if RAM[r0] == 0:
        continue
    r4 = r0
    while r4 >= r1:
        r4 -= r1

    RAM[r0] = r4

r1 = 3
r0 = 3
while r0 < 32:
    r0 += 1
    if RAM[r0] == 0:
        continue

    r4 = r0
    while r4 >= r1:
        r4 -= r1
    RAM[r0] = r4

r1 = 5
r0 = 5
while r0 < 32:
    r0 += 1
    if RAM[r0] == 0:
        continue
    r4 = r0
    while r4 >= r1:
        r4 -= r1

    RAM[r0] = r4

for i in range(len(RAM)):
    ehPrimo = RAM[i] != 0
    if ehPrimo:
        print('{}'.format(i))
