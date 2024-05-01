Cả hai lệnh `ln -s /media/rd500/docker /var/lib/docker` và `mount --rbind /media/rd500/docker /var/lib/docker` đều có thể được sử dụng để tạo liên kết giữa hai thư mục trên Linux. Tuy nhiên, chúng có sự khác biệt như sau:

`ln -s` tạo symbolic link, trong khi `mount --rbind` gắn kết thư mục:

`ln -s` tạo một liên kết tượng trưng (symbolic link) đến một thư mục khác. Khi bạn truy cập vào thư mục được liên kết, thực tế bạn đang truy cập vào thư mục khác được liên kết đến.

`mount --rbind` gắn kết một thư mục vào một thư mục khác và tất cả các thư mục con của nó. Khi bạn truy cập vào thư mục được gắn kết, thực tế bạn đang truy cập vào thư mục gốc được gắn kết.

`ln -s` không cần đặt quyền truy cập cho thư mục liên kết, trong khi `mount --rbind` cần phải đặt quyền truy cập cho thư mục gốc:

Khi tạo liên kết tượng trưng với `ln -s`, bạn không cần phải đặt quyền truy cập cho thư mục liên kết. Thay vào đó, bạn cần đặt quyền truy cập cho thư mục gốc.

Khi sử dụng `mount --rbind`, bạn cần phải đặt quyền truy cập cho thư mục gốc trước khi gắn kết thư mục con.

`ln -s` không giải quyết vấn đề về phân cấp quyền hạn, trong khi `mount --rbind` có thể giải quyết vấn đề này:

Khi sử dụng `ln -s`, nếu bạn không có quyền truy cập vào thư mục gốc, bạn sẽ không thể truy cập vào thư mục được liên kết.

Khi sử dụng `mount --rbind`, bạn có thể đặt quyền truy cập cho thư mục gốc sao cho tất cả các thư mục con của nó có thể được truy cập bởi người dùng cần truy cập.

Tóm lại, `ln -s` là một cách đơn giản để tạo liên kết tượng trưng giữa hai thư mục, trong khi `mount --rbind` có thể giải quyết vấn đề về phân cấp quyền hạn và gắn kết toàn bộ cây thư mục. Tuy nhiên, cách tiếp cận nào tốt

https://mrkandreev.name/snippets/how_to_move_docker_data_to_another_location/
https://www.ibm.com/docs/en/z-logdata-analytics/5.1.0?topic=software-relocating-docker-root-directory
