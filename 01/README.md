# Mô phỏng con lắc đơn

## Giải pháp

-   Sử dụng: ChatGPT

## Mô tả giải pháp

-   Lý thuyết: con lắc đơn là một con lắc giao động điều hòa quanh vị trí cân bằng với chu kỳ cố
    định (Ở code đặt là 2s). Sử dụng một Animation Controller để kiểm soát việc vẽ khung hình con
    lắc đơn trong StatefulWidget.

-   Để thiết lập con lắc đơn dao động qua lại, thiết lập: repeat với reverse: true để thực hiện dao
    động về vị trí cũ sau khoảng thời gian T/2 quanh 2 biên.

-   Dao động con lắc đơn có công thức như sau: x = Acos(wt), y = Asin(wt)

-   Sử dụng một Custom Painter để vẽ con lắc với x và y được tính và truyền vào dưới dạng tham số.
    AnimationBuilder sẽ lắng nghe Animation Controller và vẽ lại khung hình một cách tương ứng.

## Kết quả

![Result](/01/image/00.png)

## ChatGPT

![Prompt](/01/image/01.png) ![Prompt](/01/image/02.png) ![Prompt](/01/image/03.png)
![Prompt](/01/image/04.png)
