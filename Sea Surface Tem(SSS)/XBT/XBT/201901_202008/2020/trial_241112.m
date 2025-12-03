% 데이터 크기 설정
lat_dim = 10;     % 위도 개수
lon_dim = 8;      % 경도 개수
days_dim = 30;    % 날짜 개수

% 빈 데이터 행렬 (위도 x 경도 x 날짜) 생성 - NaN으로 초기화
data = NaN(lat_dim, lon_dim, days_dim);

% 각 날짜별로 3-4개의 랜덤 위치에만 관측값을 할당
for day = 1:days_dim
    % 현재 날짜에 대해 무작위로 3 또는 4개의 위치 선택
    num_obs = randi([3, 4]);  % 3개 또는 4개의 관측값 선택
    rand_indices = randperm(lat_dim * lon_dim, num_obs);  % 무작위 위치 선택
    
    % 각 랜덤 위치에 임의의 관측값 채우기
    for idx = 1:num_obs
        [lat_idx, lon_idx] = ind2sub([lat_dim, lon_dim], rand_indices(idx));
        data(lat_idx, lon_idx, day) = rand();  % 임의의 관측값 할당
    end
end

% 예시: 임의로 선택한 날짜에서 유효한 (NaN이 아닌) 데이터 추출
selected_day = randi([1, days_dim]);  % 임의의 날짜 선택
selected_data = data(:, :, selected_day);

% NaN이 아닌 데이터 추출 및 연산 예제 - 평균 계산
valid_data = selected_data(~isnan(selected_data));  % 유효한 값만 추출
if ~isempty(valid_data)
    mean_value = mean(valid_data);  % 유효한 값에 대한 평균 계산
    disp(['선택된 날짜 (' num2str(selected_day) ')에서 유효한 값의 평균: ' num2str(mean_value)]);
else
    disp(['선택된 날짜 (' num2str(selected_day) ')에 유효한 데이터가 없습니다.']);
end