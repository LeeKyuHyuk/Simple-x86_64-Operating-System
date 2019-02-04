## Chapter 3: VGA Text Buffer를 사용하여 화면 제어를 해보자!

[Chapter 2](https://github.com/LeeKyuHyuk/Simple-x86_64-Operating-System/blob/master/Chapter-2/README.md)에서는 간단한 부트로더를 만들어 보았습니다.  
이번 시간에는 Text Buffer를 사용하여 화면에 글자를 띄워보도록 하겠습니다.


### VGA-compatible text mode

![VGA-compatible text mode](./vga-compatible-text-mode.png)

PC가 부팅하면 가로 80문자, 세로 25문자를 화면에 띄울수 있습니다.  
화면에 글자를 띄우기위해 사용하는 Video Memory Address는 `0xB800`부터 시작합니다.  
위의 'VGA-compatible text mode'를 설명하는 그림을 보면 1문자에 글자의 속성을 정하는 Attribute 1바이트와 Character 1바이트를 사용하는것을 볼수있습니다.  
총 메모리 크기는 `80(가로) * 25(세로) * 2 = 4,000바이트`입니다.

#### Text Attribute Value

Number | Color      | Number + Bright Bit | Bright Color
------ | ---------- | ------------------- | -------------
0x0    | Black      | 0x8                 | Dark Gray
0x1    | Blue       | 0x9                 | Light Blue
0x2    | Green      | 0xa                 | Light Green
0x3    | Cyan       | 0xb                 | Light Cyan
0x4    | Red        | 0xc                 | Light Red
0x5    | Magenta    | 0xd                 | Pink
0x6    | Brown      | 0xe                 | Yellow
0x7    | Light Gray | 0xf                 | White
