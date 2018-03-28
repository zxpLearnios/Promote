1. 只有使用闭包方式创建出的对象才只会创建一次 ，如：

var autoLoginLab: UILabel = {
    let lab = UILabel()
    return lab
}()

而 var autoLoginLab: UILabel {
    let lab = UILabel()
    return lab
}   则每次调用都会重新创建一次


2.
