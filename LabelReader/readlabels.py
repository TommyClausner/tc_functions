import os
import time, re
from gtts import gTTS

pathraw=os.path.dirname(os.path.realpath(__file__))+'/'

input_file=pathraw+'labels.txt'

f = open(input_file, 'r')
list1= [" ".join(re.findall("[a-zA-Z0-9]+", x)[0]) for x in f.readlines()]
f.close()

tmp_mp3file=pathraw+'curr_label.mp3'

for x in range(0, len(list1)):

    new_var=list1[x]

    print(x+1,new_var.replace(" ", ""))

    tts = gTTS(text=new_var, lang='en')
    tts.save(tmp_mp3file)
    os.system('afplay '+tmp_mp3file)
    time.sleep(1)
    os.system('read -s -n 1 -p ""')

    os.system('rm ' + tmp_mp3file)