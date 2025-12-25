
create table Customer(
    customer_id varchar(5) primary key not null ,
    customer_full_name varchar(100) not null ,
    customer_email varchar(100) not null unique ,
    customer_phone varchar(15) not null ,
    customer_address varchar(255) not null

);
create table Room(
    room_id varchar(5) primary key not null ,
    room_type varchar(50) not null ,
    room_price decimal(10,2) not null ,
    room_status varchar(20) not null ,
    room_area int not null
);
create table Booking(
    booking_id serial primary key not null  ,
    customer_id varchar(5)  references customer(customer_id) not null ,
    room_id varchar(5)   references  room(room_id) not null ,
    check_in_date date not null ,
    check_out_date date not null ,
    total_amount decimal(10,2)

);
create table Payment(
    payment_id serial primary key not null ,
    booking_id int references booking(booking_id) not null ,
    payment_method varchar(50) not null ,
    payment_date date not null ,
    payment_amount decimal(10,2)
);
insert into customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address)
VALUES ('C001','Nguyen Anh Tu','tu.nguyen@example.com','0912345678','Hanoi, Vietnam'),
       ('C002','Tran Thi Mai','mai.tran@example.com','0923456789','Ho Chi Minh, Vientnam'),
       ('C003','Le Minh Hoang','hoang.le@example.com','0934567890','Danang,Vietnam'),
       ('C004','Pham Hoang Nam','nam.pham@example.com','0945678901','Hue, Vietnam'),
       ('C005','Vu Minh Thu','thu.vu@example.com','0956789012','Hai Phong, Vietnam');
insert into Room(room_id, room_type, room_price, room_status, room_area)
VALUES ('R001','Single','100.0','Available','25'),
       ('R002','Double','150.0','Booked','40'),
       ('R003','Suite','250.0','Available','60'),
       ('R004','Single','120.0','Booked','30'),
       ('R005','Double','160.0','Available','35');
insert into Booking(booking_id,customer_id,room_id,check_in_date,check_out_date,total_amount)
VALUES ('1','C001','R001','2025-03-01','2025-03-05','400.0'),
       ('2','C002','R002','2025-03-02','2025-03-06','600.0'),
       ('3','C003','R003','2025-03-03','2025-03-07','1000.0'),
       ('4','C004','R004','2025-03-04','2025-03-08','480.0'),
       ('5','C005','R005','2025-03-05','2025-03-09','800.0');
insert into Payment(payment_id,booking_id, payment_method, payment_date, payment_amount)
VALUES ('1','1','Cash','2025-03-05','400.0'),
       ('2','2','Credit Card','2025-03-06','600.0'),
       ('3','3','Bank Transfer','2025-03-07','1000.0'),
       ('4','4','Cash','2025-03-08','480.0'),
       ('5','5','Credit Card','2025-03-09','800.0');
--UPDATE
update booking set total_amount = total_amount *0.9 where check_in_date <'2025-3-3';
--DELETE
delete from Payment where payment_method = 'cash' and payment_amount <500;
-- Phần 2 Truy vấn dữ liệu
-- Lấy thông tin khách hàng gồm: mã khách hàng, họ tên, email, số điện thoại được sắp xếp theo họ tên khách hàng giảm dần.
select * from customer order by customer_full_name desc;
-- Lấy thông tin các phòng khách sạn gồm: mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo diện tích phòng tăng dần.
select * from Room order by room_area;
-- Lấy thông tin khách hàng và phòng khách sạn đã đặt gồm: họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select c.customer_id,
       c.customer_full_name,
       bk.room_id,
       bk.check_in_date,
       bk.check_out_date
from Customer c join Booking bk on c.customer_id = bk.customer_id;
--Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng, gồm mã khách hàng, họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán tăng dần.
select c.customer_id,
       c.customer_full_name,
       p.payment_method,
       p.payment_amount
from Customer c join Booking bk on c.customer_id = bk.customer_id
join Payment p on p.booking_id=bk.booking_id
order by p.payment_amount;
-- Lấy tất cả thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng (Z-A).
select * from Customer
order by customer_full_name desc limit 3 offset 1 ;
--Lấy danh sách khách hàng đã đặt ít nhất 2 phòng gồm : mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
select c.customer_id,
       c.customer_full_name,
       count( bk.room_id) as soluongphong
from Customer c join Booking bk on c.customer_id=bk.customer_id
group by c.customer_id,
         c.customer_full_name
having count(bk.room_id) >=2;
-- Lấy danh sách các phòng từng có ít nhất 3 khách hàng đặt, gồm mã phòng, loại phòng, giá phòng và số lần đã đặt.
select r.room_id,
       r.room_type,
       r.room_price,
       count(bk.booking_id),
       count(distinct bk.customer_id)
from Booking bk join Room r on r.room_id=bk.room_id
group by r.room_id,r.room_id, r.room_type, r.room_price
having count(distinct bk.customer_id) >=3;
--Lấy danh sách các khách hàng có tổng số tiền đã thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền đã thanh toán.
select c.customer_id,
       c.customer_full_name,
       bk.room_id,
       p.payment_amount
from Customer c join Booking bk on c.customer_id=bk.customer_id
join Payment p on bk.booking_id=p.booking_id
where p.payment_amount >1000;
--Lấy danh sách các khách hàng gồm : mã KH, Họ tên, email, sđt có họ tên chứa chữ "Minh" hoặc địa chỉ ở "Hanoi". Sắp xếp kết quả theo họ tên tăng dần.
select * from customer
where customer_full_name ilike '% minh%' or customer_address ilike'%Hanoi%';
--Lấy danh sách thông tin các phòng gồm : mã phòng, loại phòng, giá , sắp xếp theo giá phòng giảm dần.Chỉ lấy 5 phòng và bỏ qua 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 5 phòng).
select room_id,
       room_type,
       room_price
from Room
order by room_price desc limit 5 offset 5;
--Phần 3 tạo view
-- Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-04. Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng
create view view_haha as
    select c.customer_id,
           c.customer_full_name,
           r.room_type,
           r.room_id
from Customer c join Booking bk on c.customer_id= bk.customer_id
join Room r on r.room_id=bk.room_id
where bk.check_in_date < '2025-03-04';

--Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m². Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng, Ngày nhận phòng
create view view_hahaha as
    select c.customer_id,
           c.customer_full_name,
           r.room_id,
           r.room_area,
           bk.check_in_date
from Customer c join Booking bk on c.customer_id=bk.customer_id
join Room r on r.room_id=bk.room_id
where room_area > '30';
-- Phần Trigger
-- Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking. Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !” và hủy thao tác chèn dữ liệu vào bảng.
create or replace function check_insert_booking()
returns trigger
language plpgsql
as $$
    begin
        if new.check_in_date > new.check_out_date
            then raise exception 'Ngày đặt phòng không thể sau ngày trả phòng được !';
            end if;
        return new;
    end;
    $$;
create trigger check_insert_booking
    before insert on booking
    for each row
    execute function check_insert_booking();
--Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt (khi có bản ghi được INSERT vào bảng Booking).
create or replace function update_room_status_on_booking()
returns trigger
language plpgsql
as $$
    begin
        if TG_OP = 'INSERT' then update Room set room_status = 'booked'
        where new.room_id = room_id;
            end if;
        return new;
    end;
    $$;
create trigger update_room_status_on_booking
    after insert on Booking
    for each row
    execute function update_room_status_on_booking();
-- Phần 5 tạo stor procedure
-- Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
create or replace procedure add_customer(customer_id_in varchar(5),customer_full_name_in varchar(100),customer_email_in varchar(100),customer_phone_in varchar(100),customer_address_in varchar(255))
language plpgsql
as $$
    begin
        insert into customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address)
        VALUES (customer_id_in,customer_full_name_in,customer_email_in,customer_phone_in,customer_address_in);

    end;
    $$;
call add_customer('6','ly cong vuong','asdad@example.com','0382146356','thaibinh');
--Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
--Procedure này nhận các tham số đầu vào:
-- - p_booking_id: Mã đặt phòng (booking_id).
-- - p_payment_method: Phương thức thanh toán (payment_method).
-- - p_payment_amount: Số tiền thanh toán (payment_amount).
-- - p_payment_date: Ngày thanh toán (payment_date).
create or replace procedure add_payment(p_booking_id int, p_payment_method varchar(50), p_payment_amount decimal(10,2),p_payment_date date)
language plpgsql
as $$
    begin
        insert into Payment(booking_id, payment_method, payment_amount,payment_date)
        VALUES (p_booking_id,p_payment_method,p_payment_amount,p_payment_date);
    end;
    $$;
call add_payment('7','cash','600','2025-03-01');










