---
layout: post
title: 📗【Go 原理】详解 nil：接口类型和值类型的区别
date: 2019/11/12 18:00:00
---

在底层，interface 作为两个成员来实现：一个类型和一个值 `(type, value)`。`value `被称为接口的动态值，它是一个任意的具体值，而该 `type` 则为该值的类型。对于 int 值 3， 一个接口值示意性地包含 `(int, 3)`。

接口的零值是 `(nil, nil)`。换句话说。当一个接口和 `nil` 比较时，只有该接口内部的值和类型都是 `nil` 时它才等于 `nil`。比如我们在一个接口值 `i` 中存储一个 `*int` 类型的指针 `p`，则接口 `i` 的内部类型将为 `*int`。无论指针 `p` 是否为 `nil`，`i != nil` 将永远返回 `true`。
```go
var i interface{}
var p *int = nil
i = p
println(i != nil)        // true
```

指针的零值是 `nil`。因此，可以先将一个接口值转为一个指针类型，然后再与 `nil` 比较，从而判断接口内部的值是否为 `nil`。举例：
```go
println(i != nil)        // true
println(i.(*int) != nil) // false
```

下面这段代码将会一直 panic：
```go
func returnsError() error {
	var p *MyError = nil
	if bad() {
		p = ErrBad
	}
	return p // Will always return a non-nil error.
}

func main() {
	if err := returnsError(); err != nil {
		panic(nil)
	}
}
```
因为该函数返回的是一个 `error` 类型的接口，但是却有一个具体类型 `*MyError`，`err != nil` 将永远返回 `true`。

针对这个问题，可以在判断前先将 `err` 转换为具体类型`*MyError`，然后比较 err 的值是否为 nil：
```go
func main() {
	if err := returnsError(); err.(*MyError) != nil {
		panic(nil)
	}
}
```

不过更好的办法是让函数返回一个纯正的 `nil`，这也是 Go 语言中标准的错误返回方式：
```go
func returnsError() error {
	if bad() {
		return (*MyError)(err)
	}
	return nil // 直接返回一个 nil
}
```

最后，[ultimate-go](https://github.com/hoanhan101/ultimate-go/blob/master/go/design/error_5.go) 也提供了一个类似的案例。

---
参考资料：
* [详解 interface 和 nil](https://my.oschina.net/goal/blog/194233)
* [Go中 error 类型的 nil 值和 nil](https://my.oschina.net/chai2010/blog/117923)