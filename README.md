## 颜色模型转换
`rgb2color(int R,int G,int B):int Color`

`color2rgb(int Color):int R,int G,int B`

`argb2color(int A,int R,int G,int B):int Color`

`color2argb(int Color):int A,int R,int G,int B`

`rgb2hsv(int R,int G,int B):int H,int S,int V`

`hsv2rgb(int H,int S,int V):int R,int G,int B`

`color2hsv(int Color):int H,int S,int V`

`hsv2color(int H,int S,int V):int Color`

`rgb2hsl(int R,int G,int B):int H,int S,int L`

`hsl2rgb(int H,int S,int L):int R,int G,int B`

`color2hsl(int Color):int H,int S,int L`

`hsl2color(int H,int S,int L):int Color`

## ARGB
`alpha(int Color):int A`

`alpha(int Color,int A):int Color`

`red(int Color):int R`

`red(int Color,int R):int Color`

`green(int Color):int G`

`green(int Color,int G):int Color`

`blue(int Color):int B`

`blue(int Color,int B):int Color`

## HEX
`parse(string Hex):int Color`

`formar(int Color):string Hex`

## 自动模型转换
`to_color(obj):int Color`

`to_rgb(obj):table RGB`

`to_hsv(obj):table HSV`

`to_hsl(obj):table HSL`

`to_hex(obj):string Hex`

`is_dark(obj):boolean is`

## 颜色评估器
`eval(obj s,obj e,boolean is):(number f):int Color`
