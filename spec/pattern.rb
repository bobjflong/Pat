require 'ribimaybe'
require 'pat'

context '#pat' do
  
  include Ribimaybe::Maybe

  it 'should work' do
    ans = [1,2,3].pat('x:y:z') do |v|
      [v.x, v.y, v.z]
    end
    expect(ans).to eq [pure(1), pure(2), pure([3])]
  end

  it 'should allow computations to pass' do
    ans = [1,2,3].pat('x:y:_') do |v|
      Just do |x,y|
        x + y
      end.run(v.x, v.y)
    end
    expect(ans).to eq Just(3)
  end

  it 'should allow computations to fail' do
    ans = [1].pat('x:y:_') do |v|
      Just do |x,y|
        x + y
      end.run(v.x, v.y)
    end
    expect(ans).to eq Nothing
  end
end
