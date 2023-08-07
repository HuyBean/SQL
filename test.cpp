// C++ code
//

// Khai báo để đi dây thẩm mỹ
const int led1 = 4; // Red
const int led2 = 5; // Green
const int led3 = 6; // Blue
const int led4 = 3; // White
const int led5 = 2; // Orange
const int led6 = 1; // Yellow

// Khai báo chân kết nối nút nhấn
const int buttonPin = 12; // Button

// Khai báo biến lưu thời điểm nhấn nút
unsigned long buttonPressTime = 0;

void setup()
{
    // Thiết lập chân kết nối đèn LED là OUTPUT
    pinMode(led1, OUTPUT);
    pinMode(led2, OUTPUT);
    pinMode(led3, OUTPUT);
    pinMode(led4, OUTPUT);
    pinMode(led5, OUTPUT);
    pinMode(led6, OUTPUT);

    // Thiết lập chân kết nối nút nhấn là INPUT_PULLUP
    pinMode(buttonPin, INPUT_PULLUP);
}

void loop()
{
    // Đọc trạng thái của nút nhấn
    bool buttonState = digitalRead(buttonPin);

    // Kiểm tra xem nút nhấn có được nhấn hay không
    if (buttonState == HIGH)
    {
        // Lưu thời điểm nhấn nút
        if (buttonPressTime == 0)
        {
            buttonPressTime = millis();
        }

        // Kiểm tra thời gian nhấn nút
        unsigned long buttonHoldTime = millis() - buttonPressTime;
        if (buttonHoldTime <= 6000)
        {
            // Bật LED 4, 5, 6
            digitalWrite(led4, HIGH);
            digitalWrite(led5, HIGH);
            digitalWrite(led6, HIGH);

            // Chớp tắt LED 1, 2, 3
            digitalWrite(led1, HIGH);
            delay(1000);
            digitalWrite(led1, LOW);
            digitalWrite(led2, HIGH);
            delay(1000);
            digitalWrite(led2, LOW);
            digitalWrite(led3, HIGH);
            delay(1000);
            digitalWrite(led3, LOW);
        }
        else
        {
            // Bật tất cả các LED
            digitalWrite(led1, HIGH);
            digitalWrite(led2, HIGH);
            digitalWrite(led3, HIGH);
            digitalWrite(led4, HIGH);
            digitalWrite(led5, HIGH);
            digitalWrite(led6, HIGH);
        }
    }
    else
    {
        // Reset thời điểm nhấn nút
        buttonPressTime = 0;

        digitalWrite(led4, LOW);
        digitalWrite(led5, LOW);
        digitalWrite(led6, LOW);
        digitalWrite(led1, HIGH);
        digitalWrite(led2, HIGH);
        digitalWrite(led3, HIGH);
    }
}
