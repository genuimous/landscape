-- raise_custom_error
create procedure raise_custom_error
  @error_text varchar(1000)
as
begin
  declare @error_message varchar(2047)

  set @error_message = '{' + @error_text + '}'

  raiserror(@error_message, 16, 1)
end

-- consts
create table consts
(
  id bigint identity(1, 1) not null,
  identifier varchar(30) not null,
  visible_name nvarchar(250) not null,
  value_string varchar(255) null,
  value_int bigint null,
  value_float float null,
  value_datetime datetime null,
  value_bool bit null
)

alter table consts add constraint pk_consts primary key(id)
create unique index ui_consts_identifier on consts(identifier)

-- const_string
create function const_string
(
  @identifier varchar(30)
)
returns varchar(255)
as
begin
  declare @result varchar(255)

  select @result = value_string
  from dbo.consts
  where identifier = @identifier

  return @result
end

-- const_int
create function const_int
(
  @identifier varchar(30)
)
returns int
as
begin
  declare @result int

  select @result = value_int
  from dbo.consts
  where identifier = @identifier

  return @result
end

-- const_float
create function const_float
(
  @identifier varchar(30)
)
returns float
as
begin
  declare @result float

  select @result = value_float
  from dbo.consts
  where identifier = @identifier

  return @result
end

-- const_datetime
create function const_datetime
(
  @identifier varchar(30)
)
returns datetime
as
begin
  declare @result datetime

  select @result = value_datetime
  from dbo.consts
  where identifier = @identifier

  return @result
end

-- const_bool
create function const_bool
(
  @identifier varchar(30)
)
returns bit
as
begin
  declare @result bit

  select @result = value_bool
  from dbo.consts
  where identifier = @identifier

  return @result
end

-- planet_radius
create function planet_radius()
returns int
as
begin
  declare @result int

  set @result = dbo.const_int('planet_radius')

  return @result
end

-- latitude_step
create function latitude_step()
returns int
as
begin
  declare @result int

  set @result = dbo.const_int('latitude_step')

  return @result
end

-- longitude_step
create function longitude_step()
returns int
as
begin
  declare @result int

  set @result = dbo.const_int('longitude_step')

  return @result
end

-- latitude_delta
create function latitude_delta
(
  @latitude int,
  @near_latitude int
)
returns int
as
begin
  declare @result int

  if @latitude >= -32400000 and @latitude <= 32400000 and @near_latitude >= -32400000 and @near_latitude <= 32400000
  begin
    set @result = @latitude - @near_latitude
  end
  else
  begin
    set @result = null
  end

  return @result
end

-- longitude_delta
create function longitude_delta
(
  @longitude int,
  @near_longitude int
)
returns int
as
begin
  declare @result int

  if @longitude >= 0 and @longitude < 129600000 and @near_longitude >= 0 and @near_longitude < 129600000
  begin
    if abs(@longitude - @near_longitude) <= 64800000
    begin
      set @result = @longitude - @near_longitude
    end
    else
    begin
      if @longitude >= @near_longitude
      begin
        set @result = @longitude - @near_longitude - 129600000
      end
      else
      begin
        set @result = @longitude - @near_longitude + 129600000
      end
    end
  end
  else
  begin
    set @result = null
  end

  return @result
end

-- users
create table users
(
  id bigint identity(1, 1) not null,
  login varchar(30) not null,
  visible_name nvarchar(250) not null,
  is_admin bit not null
)

alter table users add constraint pk_users primary key(id)
create unique index ui_users_login on users(login)

-- user_visible_name
create function user_visible_name
(
  @login varchar(30)
)
returns nvarchar(250)
as
begin
  declare @result nvarchar(250)

  select @result = visible_name
  from dbo.users
  where login = @login

  return @result
end

-- points
create table points
(
  id bigint identity(1, 1) not null,
  latitude int not null,
  longitude int not null,
  altitude smallint not null,
  measured datetime null
)

alter table points add constraint pk_points primary key(id)
alter table points add constraint ck_points_latitude check(latitude >=(-32400000) and latitude <= 32400000 and latitude % latitude_step() = 0)
alter table points add constraint ck_points_longitude check(longitude >= 0 and longitude < 129600000 and longitude % longitude_step() = 0)
create unique index ui_points_coordinates on points(latitude, longitude)

-- point_altitude
create function point_altitude
(
  @point_id bigint
)
returns smallint
as
begin
  declare @result smallint

  select @result = altitude
  from dbo.points
  where id = @point_id

  return @result
end

-- find_point
create function find_point
(
  @latitude int,
  @longitude int
)
returns bigint
as
begin
  declare @result bigint

  select @result = id
  from dbo.points
  where latitude = @latitude and longitude = @longitude

  return @result
end

-- near_point
create function near_point
(
  @latitude int,
  @longitude int
)
returns bigint
as
begin
  declare @result bigint

  declare @latitude_step int
  declare @longitude_step int

  declare @near_latitude int
  declare @near_longitude int

  set @latitude_step = dbo.latitude_step()
  set @longitude_step = dbo.longitude_step()

  -- определяем широту ближней точки
  if abs(@latitude) % @latitude_step > @latitude_step / 2
  begin
    set @near_latitude = round(@latitude / @latitude_step, 0) * @latitude_step + @latitude_step *(@latitude / abs(@latitude))
  end
  else
  begin
    set @near_latitude = round(@latitude / @latitude_step, 0) * @latitude_step
  end

  -- определяем долготу ближней точки
  if @longitude % @longitude_step > @longitude_step / 2
  begin
    set @near_longitude = round(@longitude / @longitude_step, 0) * @longitude_step + @longitude_step
  end
  else 
  begin
    set @near_longitude = round(@longitude / @longitude_step, 0) * @longitude_step
  end
  
  -- проверка на максимальное значение долготы
  if @near_longitude = 129600000
  begin
    set @near_longitude = 0
  end

  -- результат
  set @result = dbo.find_point(@near_latitude, @near_longitude)

  return @result
end

-- area
create function area
(
  @min_latitude int,
  @max_latitude int,
  @from_longitude int,
  @to_longitude int
)
returns @result table
(
  point_id bigint
)
as
begin
  if @from_longitude <= @to_longitude
  begin
    insert into @result
    (
      point_id
    )
    select
      id
    from
      dbo.points
    where
      latitude between @min_latitude and @max_latitude
      and longitude between @from_longitude and @to_longitude
  end
  else
  begin
    insert into @result
    (
      point_id
    )
    select
      id
    from
      dbo.points
    where
      latitude between @min_latitude and @max_latitude
      and longitude between @from_longitude and 129599999

    union all

    select
      id
    from
      dbo.points
    where
      latitude between @min_latitude and @max_latitude
      and longitude between 0 and @to_longitude
  end

  return
end

-- insert_point
create procedure insert_point
  @id bigint output,
  @latitude int,
  @longitude int,
  @altitude smallint,
  @measured datetime = null
as
begin
  set nocount on
  set xact_abort on

  select @id = id
  from dbo.points
  where latitude = @latitude and longitude = @longitude

  if @id is null
  begin
    begin transaction

    insert into dbo.points
    (
      latitude,
      longitude,
      altitude,
      measured
    )
    values
    (
      @latitude,
      @longitude,
      @altitude,
      isnull(@measured, getdate())
    )

    commit transaction

    set @id = @@identity
  end
  else
  begin
    begin transaction

    update
      dbo.points
    set
      altitude = @altitude,
      measured = isnull(@measured, getdate())
    where
      id = @id

    commit transaction
  end
end

-- categories
create table categories
(
  id bigint identity(1, 1) not null,
  visible_name nvarchar(250) not null,
  obsolete bit not null
)

alter table categories add constraint pk_categories primary key(id)

-- places
create table places
(
  id bigint identity(1, 1) not null,
  category_id bigint not null,
  point_id bigint not null,
  latitude_delta int not null,
  longitude_delta int not null,
  identity_name nvarchar(50) not null,
  visible_name nvarchar(250) not null,
  comment_text ntextnull,
  created datetime not null,
  created_by varchar(30) not null
)

alter table places add constraint pk_places primary key(id)
alter table places add constraint fk_places_point foreign key(point_id) references points(id)
alter table places add constraint fk_places_category foreign key(category_id) references categories(id)
alter table places add constraint df_places_created default(getdate()) for created
alter table places add constraint df_places_created_by default(user_name()) for created_by
create unique index ui_places_identity on places(category_id, created_by, identity_name)

-- place_pictures
create table place_pictures
(
  id bigint identity(1, 1) not null,
  place_id bigint not null,
  visible_name nvarchar(250) not null,
  picture_data image null,
  created datetime not null,
  created_by varchar(30) not null,
)

alter table place_pictures add constraint pk_place_pictures primary key(id)
alter table place_pictures add constraint fk_place_pictures_place foreign key(place_id) references places(id)
alter table place_pictures add constraint df_place_pictures_created default(getdate()) for created
alter table place_pictures add constraint df_place_pictures_created_by default(user_name()) for created_by

-- place_picture_count
create function place_picture_count
(
  @place_id bigint
)
returns int
as
begin
  declare @result int

  select @result = count(*)
  from dbo.place_pictures
  where place_id = @place_id

  return @result
end

-- tracks
create table tracks
(
  id bigint identity(1, 1) not null,
  category_id bigint not null,
  visible_name nvarchar(250) not null,
  comment_text text,
  created datetime not null,
  created_by varchar(30) not null
)

alter table tracks add constraint pk_tracks primary key(id) 
alter table tracks add constraint fk_tracks_category foreign key(category_id) references categories(id)
alter table tracks add constraint df_tracks_created default(getdate()) for created
alter table tracks add constraint df_tracks_created_by default(user_name()) for created_by
create index i_tracks_category_user on tracks(category_id, created_by)

-- tracks_data
create table tracks_data
(
  track_id bigint not null,
  point_num smallint not null,
  point_id bigint not null,
  latitude_delta int not null,
  longitude_delta int not null
)

alter table tracks_data add constraint pk_tracks_data primary key(track_id, point_num)
alter table tracks_data add constraint fk_tracks_data_track foreign key(track_id) references tracks(id)
alter table tracks_data add constraint fk_tracks_data_point foreign key(point_id) references points(id)

-- track_points
create function track_points
(
  @track_id bigint
)
returns @result table 
(
  latitude int,
  longitude int,
  altitude smallint
)
as
begin
  insert into @result
  (
    latitude,
    longitude,
    altitude
  )
  select 
    p.latitude + td.latitude_delta latitude,
    (p.longitude + td.longitude_delta + 129600000) % 129600000 longitude,
    p.altitude
  from 
    dbo.tracks_data td inner join
    dbo.points p on p.id = td.point_id
  where 
    td.track_id = @track_id
  order by 
    td.point_num

  return
end

-- track_step_count
create function track_step_count
(
  @track_id bigint
)
returns int
as
begin
  declare @result int

  select @result = count(*) - 1
  from dbo.tracks_data
  where track_id = @track_id

  return @result
end

-- add_track_point
create procedure add_track_point
  @track_id bigint,
  @point_num smallint,
  @latitude int,
  @longitude int
as
begin
  set nocount on
  set xact_abort on

  declare @point_id bigint
  declare @latitude_delta int
  declare @longitude_delta int

  declare @near_latitude int
  declare @near_longitude int

  -- получим точку поверхности
  set @point_id = dbo.near_point(@latitude, @longitude)

  if @point_id is not null
  begin
    -- получим координаты точки
    select
      @near_latitude = latitude,
      @near_longitude = longitude
    from
      dbo.points
    where
      id = @point_id

    -- получим отклонение заданных координат от точки
    set @latitude_delta = dbo.latitude_delta(@latitude, @near_latitude)
    set @longitude_delta = dbo.longitude_delta(@longitude, @near_longitude)

    -- сохраним данные
    begin transaction

    insert into dbo.tracks_data
    (
      track_id,
      point_id,
      latitude_delta,
      longitude_delta,
      point_num
    )
    values
    (
      @track_id,
      @point_id,
      @latitude_delta,
      @longitude_delta,
      @point_num
    )

    commit transaction
  end
  else
  begin
    exec dbo.raise_custom_error 'Нет данных поверхности!'
  end
end

-- create_category
create procedure create_category
  @id bigint output,
  @visible_name nvarchar(250),
  @obsolete bit
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  insert into dbo.categories
  (
    visible_name,
    obsolete
  )
  values
  (
    @visible_name,
    @obsolete
  )

  commit transaction

  set @id = @@identity
end

-- edit_category
create procedure edit_category
  @id bigint,
  @visible_name nvarchar(250),
  @obsolete bit
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  update
    dbo.categories
  set
    visible_name = @visible_name,
    obsolete = @obsolete
  where
    id = @id

  commit transaction
end

-- delete_category
create procedure delete_category
  @id bigint
as
begin
  set nocount on
  set xact_abort on

  declare @track_id bigint
  declare @place_id bigint

  declare @tracks cursor
  declare @places cursor

  begin transaction

  -- удаляем места
  set @places = cursor scroll
  for
  select id
  from dbo.places
  where category_id = @id

  open @places
  fetch next from @places into @place_id

  while @@fetch_status = 0
  begin
    exec dbo.delete_place @place_id
    fetch next from @places into @place_id
  end

  close @places

  -- удаляем треки
  set @tracks = cursor scroll
  for
  select id
  from dbo.tracks
  where category_id = @id

  open @tracks
  fetch next from @tracks into @track_id

  while @@fetch_status = 0
  begin
    exec dbo.delete_track @track_id
    fetch next from @tracks into @track_id
  end

  close @tracks

  delete
  from dbo.categories
  where id = @id

  commit transaction
end

-- create_place
create procedure create_place
  @id bigint output,
  @category_id bigint,
  @latitude int,
  @longitude int,
  @identity_name nvarchar(50),
  @visible_name nvarchar(250)
as
begin
  set nocount on
  set xact_abort on

  declare @point_id bigint
  declare @latitude_delta int
  declare @longitude_delta int

  declare @near_latitude int
  declare @near_longitude int

  -- получим точку поверхности
  set @point_id = dbo.near_point(@latitude, @longitude)

  if @point_id is not null
  begin
    -- получим координаты точки
    select
      @near_latitude = latitude,
      @near_longitude = longitude
    from
      dbo.points
    where
      id = @point_id

    -- получим отклонение заданных координат от точки
    set @latitude_delta = dbo.latitude_delta(@latitude, @near_latitude)
    set @longitude_delta = dbo.longitude_delta(@longitude, @near_longitude)

    -- сохраним данные
    begin transaction

    insert into dbo.places
    (
      category_id,
      point_id,
      latitude_delta,
      longitude_delta,
      identity_name,
      visible_name
    )
    values
    (
      @category_id,
      @point_id,
      @latitude_delta,
      @longitude_delta,
      @identity_name,
      @visible_name
    )

    commit transaction

    set @id = @@identity
  end
  else
  begin
    exec dbo.raise_custom_error 'Нет данных поверхности!'
  end
end

-- edit_place
create procedure edit_place
  @id bigint,
  @category_id bigint,
  @latitude int,
  @longitude int,
  @identity_name nvarchar(50),
  @visible_name nvarchar(250)
as
begin
  set nocount on
  set xact_abort on

  declare @point_id bigint
  declare @latitude_delta int
  declare @longitude_delta int

  declare @near_latitude int
  declare @near_longitude int

  -- получим точку поверхности
  set @point_id = dbo.near_point(@latitude, @longitude)

  if @point_id is not null
  begin
    -- получим координаты точки
    select
      @near_latitude = latitude,
      @near_longitude = longitude
    from
      dbo.points
    where
      id = @point_id

    -- получим отклонение заданных координат от точки
    set @latitude_delta = dbo.latitude_delta(@latitude, @near_latitude)
    set @longitude_delta = dbo.longitude_delta(@longitude, @near_longitude)

    -- сохраним данные
    begin transaction

    update
      dbo.places
    set
      category_id = @category_id,
      point_id = @point_id,
      latitude_delta = @latitude_delta,
      longitude_delta = @longitude_delta,
      identity_name = @identity_name,
      visible_name = @visible_name
    where
      id = @id

    commit transaction
  end
  else
  begin
    exec dbo.raise_custom_error 'Нет данных поверхности!'
  end
end

-- delete_place
create procedure delete_place
  @id bigint
as
begin
  set nocount on
  set xact_abort on

  declare @place_picture_id bigint

  declare @place_pictures cursor

  begin transaction

  -- удаляем картинки
  set @place_pictures = cursor scroll
  for
  select id
  from dbo.place_pictures
  where place_id = @id

  open @place_pictures
  fetch next from @place_pictures into @place_picture_id

  while @@fetch_status = 0
  begin
    exec dbo.delete_place_picture @place_picture_id
    fetch next from @place_pictures into @place_picture_id
  end

  close @place_pictures

  delete
  from dbo.places
  where id = @id

  commit transaction
end

-- insert_place
create procedure insert_place
  @id bigint output,
  @category_id bigint,
  @latitude int,
  @longitude int,
  @identity_name nvarchar(50),
  @visible_name nvarchar(250)
as
begin
  set nocount on
  set xact_abort on

  -- посмотрим, есть ли такое место
  select
    @id = id
  from
    dbo.places
  where
    category_id = @category_id 
    and identity_name = @identity_name
    and created_by = user_name()

  -- если нет, то надо создать, иначе отредактировать
  if @id is null
  begin
    exec dbo.create_place
      @id,
      @category_id,
      @latitude,
      @longitude,
      @identity_name,
      @visible_name
  end
  else
  begin
    exec dbo.edit_place
      @id,
      @category_id,
      @latitude,
      @longitude,
      @identity_name,
      @visible_name
  end
end

-- create_place_picture
create procedure create_place_picture
  @id bigint output,
  @place_id bigint,
  @visible_name nvarchar(250)
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  insert into dbo.place_pictures
  (
    place_id,
    visible_name
  )
  values
  (
    @place_id,
    @visible_name
  )

  commit transaction

  set @id = @@identity
end

-- edit_place_picture
create procedure edit_place_picture
  @id bigint,
  @visible_name nvarchar(250)
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  update
    dbo.place_pictures
  set
    visible_name = @visible_name
  where
    id = @id

  commit transaction
end

-- delete_place_picture
create procedure delete_place_picture
  @id bigint
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  delete
  from dbo.place_pictures
  where id = @id

  commit transaction
end

-- create_track
create procedure create_track
  @id bigint output,
  @category_id bigint,
  @visible_name nvarchar(250)
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  insert into dbo.tracks
  (
    category_id,
    visible_name
  )
  values
  (
    @category_id,
    @visible_name
  )

  commit transaction

  set @id = @@identity
end

-- edit_track
create procedure edit_track
  @id bigint,
  @category_id bigint,
  @visible_name nvarchar(250)
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  update
    dbo.tracks
  set
    visible_name = @visible_name,
    category_id = @category_id
  where
    id = @id

  commit transaction
end

-- delete_track
create procedure delete_track
  @id bigint
as
begin
  set nocount on
  set xact_abort on

  begin transaction

  delete
  from dbo.track_data
  where track_id = @id

  delete
  from dbo.tracks
  where id = @id

  commit transaction
end

-- add_track_point
create procedure add_track_point
  @track_id bigint,
  @point_num smallint,
  @latitude int,
  @longitude int
as
begin
  set nocount on
  set xact_abort on

  declare @point_id bigint
  declare @latitude_delta int
  declare @longitude_delta int

  declare @near_latitude int
  declare @near_longitude int

  -- получим точку поверхности
  set @point_id = dbo.near_point(@latitude, @longitude)

  if @point_id is not null
  begin
    -- получим координаты точки
    select
      @near_latitude = latitude,
      @near_longitude = longitude
    from
      dbo.points
    where
      id = @point_id

    -- получим отклонение заданных координат от точки
    set @latitude_delta = dbo.latitude_delta(@latitude, @near_latitude)
    set @longitude_delta = dbo.longitude_delta(@longitude, @near_longitude)

    -- сохраним данные
    begin transaction

    insert into dbo.track_data
    (
      track_id,
      point_id,
      latitude_delta,
      longitude_delta,
      point_num
    )
    values
    (
      @track_id,
      @point_id,
      @latitude_delta,
      @longitude_delta,
      @point_num
    )

    commit transaction
  end
  else
  begin
    exec dbo.raise_custom_error 'Нет данных поверхности!'
  end
end

-- all_tracks
create view all_tracks
as
select
  id,
  category_id,
  visible_name,
  dbo.track_step_count(id) step_count,
  comment_text,
  created,
  created_by
from
  dbo.tracks

-- user_tracks
create view user_tracks
as
select
  id,
  category_id,
  visible_name,
  dbo.track_step_count(id) step_count,
  comment_text,
  created
from
  dbo.tracks
where
  created_by = user

-- all_places
create view all_places
as
select
  places.id,
  places.category_id,
  points.latitude + places.latitude_delta latitude,
  (points.longitude + places.longitude_delta + 129600000) % 129600000 longitude,
  points.altitude,
  places.identity_name,
  places.visible_name,
  dbo.place_picture_count(places.id) picture_count,
  places.comment_text,
  places.created,
  places.created_by
from
  dbo.places inner join
  dbo.points on points.id = places.point_id

-- user_places
create view user_places
as
select
  places.id,
  places.category_id,
  points.latitude + places.latitude_delta latitude,
  (points.longitude + places.longitude_delta + 129600000) % 129600000 longitude,
  points.altitude,
  places.identity_name,
  places.visible_name,
  dbo.place_picture_count(places.id) picture_count,
  places.comment_text,
  places.created
from
  dbo.places inner join
  dbo.points on points.id = places.point_id
where
  places.created_by = user