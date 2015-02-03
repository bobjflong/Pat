require 'ribimaybe'
require 'pat'
require 'pry'

context '#pat' do

  include Ribimaybe::Maybe

  it 'should work with large lists' do
    xs = *(1...4000000)
    ans = xs.pat('x:y:z:_') do |v|
      Just { |x,y,z| [x,y,z] }.run(v.x, v.y, v.z)
    end
    expect(ans).to eq pure([1,2,3])
  end
end
