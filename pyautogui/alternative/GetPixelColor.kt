import java.awt.*

fun getColorAt(): Color {
    return Robot().getPixelColor(16, 16)
}

fun main() {
    val tic = System.currentTimeMillis()
    getColorAt()
    val tac = System.currentTimeMillis()
    println(tac - tic)
}
